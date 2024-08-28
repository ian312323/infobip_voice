import Flutter
import UIKit
import Foundation
import InfobipRTC
import OSLog
import PushKit

public class SwiftInfobipWebrtcSdkFlutterPlugin: NSObject, FlutterPlugin, InfobipPlugin , PKPushRegistryDelegate, IncomingCallEventListener{
    
    
    private var voipRegistry: PKPushRegistry?
    
    
    public func setView(streamId: String) {
        
    }
    
    public func setTrack(streamId: String, track: VideoTrack?) {
        
    }
    
    public func clearViews() {
        
    }
    
    typealias Handler = (FlutterMethodCall, @escaping FlutterResult) throws -> Void
    
    let channel: FlutterMethodChannel
    let callEventChannel: FlutterMethodChannel
    let incomingCallMethodChannel: FlutterMethodChannel

    var mapping: [String: Handler] = [:]
    
    var token: String? = nil
    var pushConfigId: String? = nil
    
    var infobipRTC: InfobipRTC{
        get{
            return getInfobipRTCInstance()
        }
    }
    
    
    
    init(_ channel: FlutterMethodChannel, _ callEventChannel: FlutterMethodChannel, _ incomingCallMethodChannel: FlutterMethodChannel) {
        self.channel = channel
        self.callEventChannel = callEventChannel
        self.incomingCallMethodChannel = incomingCallMethodChannel
        
        super.init()
        
        
        // TODO check whether it's possible to do something similar as in android lib,
        //  with custom annotations and runtime map population
        mapping = [
            "call": call,
            "callPhoneNumber": callPhoneNumber,
            "hangup": hangup,
            "mute": mute,
            "dmtf": sendDMTF,
            "speakerphone": speakerphone,
            "handleIncomingCall": handleIncomingCall,
            "accept": accept,
            "decline": decline,
            "setToken": setToken
        ]
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        do {
            let handler = mapping[call.method]
            
            try handler!(call, result)
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "infobip_webrtc_sdk_flutter", binaryMessenger: registrar.messenger())
        let callEventChannel = FlutterMethodChannel(name: "infobip_webrtc_sdk_flutter_call_event", binaryMessenger: registrar.messenger())
        let incomingCallChannel = FlutterMethodChannel(name: "infobip_webrtc_sdk_flutter_incoming_call", binaryMessenger: registrar.messenger())
        
        let instance = SwiftInfobipWebrtcSdkFlutterPlugin(channel, callEventChannel, incomingCallChannel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    
    
    public func emitEvent(event: String, data: Codable?) {
        callEventChannel.invokeMethod("onEvent", arguments: [
            "event": event,
            "data": data?.toJsonString()
        ])
    }
    
    // Pushkit Stuff
    public func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        if token == nil || pushConfigId == nil {
            return
        }
        
        if type == .voIP {
            let deviceToken = pushCredentials.token
            let debug = isDebug()
            
            os_log("isDebug: %@", debug ? "true" : "false")
            os_log("Push token: %@", deviceToken as CVarArg)
            infobipRTC.enablePushNotification(token!, pushCredentials: pushCredentials, debug: debug, pushConfigId: pushConfigId!)
        }
    }
    
    public func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        if type == .voIP {
            os_log("Received VoIP Push Notification %@", payload)
            // print isIncomingCall(payload)
            os_log("isIncomingCall: %@", infobipRTC.isIncomingCall(payload) ? "true" : "false")
            if infobipRTC.isIncomingCall(payload) {
                infobipRTC.handleIncomingCall(payload, self)
            }
        }
    }
    
    public func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        if token == nil{
            return
        }
        infobipRTC.disablePushNotification(token!)
    }
    
    
    
    public func onIncomingWebrtcCall(_ incomingWebrtcCallEvent: IncomingWebrtcCallEvent) {
        let incomingWebrtcCall = incomingWebrtcCallEvent.incomingWebrtcCall
        incomingWebrtcCall.webrtcCallEventListener = DefaultWebRTCCallEventListener(plugin: self)
        let json = incomingWebrtcCall.toFlutterModel().toJsonString()
        incomingCallMethodChannel.invokeMethod("onEvent", arguments: [
            "event": "onIncomingCall",
            "data":json
        ])
    }
    
    
    public func setToken(_ methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = methodCall.arguments as! [String: Any]
        let newToken: String = args["token"] as! String
        let newpushConfigId: String = args["pushConfigId"] as! String
        token = newToken
        pushConfigId = newpushConfigId
        createPushRegistry()
        os_log("Token set")
        result(nil)
    }
    
    
    /* SDK API */
    public func call(_ methodCall: FlutterMethodCall, result: @escaping FlutterResult) throws {
        let args = methodCall.arguments as! [String: Any]
        let destination: String = args["destination"] as! String
        if(token == nil){
            result(FlutterError(code: "UNAUTHENTICATED", message: "Token not set", details: nil))
            return
        }
        
        let callWebrtcRequest  = CallWebrtcRequest(token!, destination: destination, webrtcCallEventListener: DefaultWebRTCCallEventListener(plugin: self)
        )
        
        do{
            let webrtcCall = try infobipRTC.callWebrtc(callWebrtcRequest)
            let json = webrtcCall.toFlutterModel().toJsonString()
            result(json)
            os_log("Call started")
        }catch let error{
            result(FlutterError(code: "CALL_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    
    public func callPhoneNumber(_ methodCall: FlutterMethodCall, result: @escaping FlutterResult) throws {
        let args = methodCall.arguments as! [String: Any]
        if(token == nil){
            result(FlutterError(code: "UNAUTHENTICATED", message: "Token not set", details: nil))
            return
        }
        
        let destination: String = args["destination"] as! String
        let callPhoneRequest = CallPhoneRequest(token!, destination: destination,phoneCallEventListener: DefaultCallEventHandler(self))
        os_log("call started")
        do{
            let phoneCall = try infobipRTC.callPhone(callPhoneRequest)
            let json = phoneCall.toFlutterModel().toJsonString()
            result(json)
        }catch let error as CallError {
            let json = error.toFlutterModel().toJsonString()
            result(json)
        }
    }
    
    
    public func hangup(_ methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        infobipRTC.getActiveCall()?.hangup()
        result(nil)
    }
    
    public func mute(_ methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = methodCall.arguments as! [String: Any]
        let mute: Bool = args["mute"] as! Bool
        do{
            try infobipRTC.getActiveCall()?.mute(mute)
            result(nil)
        }catch let error{
            result(FlutterError(code: "MUTE_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    public func speakerphone(_ methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = methodCall.arguments as! [String: Any]
        let enabled: Bool = args["enabled"] as! Bool
        
        if let activeCall = infobipRTC.getActiveCall() {
            activeCall.speakerphone(enabled) { error in
                if let error = error {
                    // Handle error if it exists
                    print("Error occurred: \(error)")
                    result(FlutterError(code: "SPEAKER_ERROR", message: "Speakerphone error occurred", details: nil))
                } else {
                    // The speakerphone action succeeded
                    print("Speakerphone action succeeded")
                    result(nil)
                }
            }
        } else {
            // Handle scenario where there is no active call
            os_log("No active call found")
            result(FlutterError(code: "NO_ACTIVE_CALL", message: "No active call found", details: nil))
        }
    }
    
    // You can simulate digit press during the call by sending DTMF codes (Dual-Tone Multi-Frequency).
    // This is achieved via the sendDTMF method. Valid DTMF codes are digits 0 -9, letters Á to D, symbols * and #.
    public func sendDMTF(_ methodCall: FlutterMethodCall, result: @escaping FlutterResult){
        let args = methodCall.arguments as! [String: Any]
        let dmtf: String = args["dmtf"] as! String
        
        let call = infobipRTC.getActiveCall()
        do{
            try call?.sendDTMF(dmtf)
        }catch let error{
            result(FlutterError(code: "DMTF_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    
    func createPushRegistry() {
        os_log("Creating push registry")
        voipRegistry = isSimulator() ? InfobipSimulator(token: token!) : PKPushRegistry(queue: DispatchQueue.main)
        voipRegistry?.desiredPushTypes = [PKPushType.voIP]
        voipRegistry?.delegate = self
    }
    
    public func handleIncomingCall(_ methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        
    }
    
    public func accept(_ methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        let incomingCall = infobipRTC.getActiveCall() as? IncomingCall
        incomingCall?.accept()
        result(nil)
    }
    
    public func decline(_ methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        let incomingCall = infobipRTC.getActiveCall() as? IncomingCall
        incomingCall?.decline()
        result(nil)
    }
    
    func isSimulator() -> Bool{
#if targetEnvironment(simulator)
        return true
#else
        return false
#endif
    }
    
    func isDebug() -> Bool {
#if DEBUG
        return true
#else
        return false
#endif
    }
    
    
    
}



