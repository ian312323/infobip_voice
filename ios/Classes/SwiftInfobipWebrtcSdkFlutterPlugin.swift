import Flutter
import UIKit
import Foundation
import InfobipRTC
import OSLog

public class SwiftInfobipWebrtcSdkFlutterPlugin: NSObject, FlutterPlugin, InfobipPlugin {
    public func setView(streamId: String) {
        
    }
    
    public func setTrack(streamId: String, track: VideoTrack?) {
        
    }
    
    public func clearViews() {
        
    }
    
    

    typealias Handler = (FlutterMethodCall, @escaping FlutterResult) throws -> Void
    
    let channel: FlutterMethodChannel
    let callEventChannel: FlutterMethodChannel
    
    var mapping: [String: Handler] = [:]
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "infobip_webrtc_sdk_flutter", binaryMessenger: registrar.messenger())
        let callEventChannel = FlutterMethodChannel(name: "infobip_webrtc_sdk_flutter_call_event", binaryMessenger: registrar.messenger())
        let instance = SwiftInfobipWebrtcSdkFlutterPlugin(channel, callEventChannel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    init(_ channel: FlutterMethodChannel, _ callEventChannel: FlutterMethodChannel) {
        self.channel = channel
        self.callEventChannel = callEventChannel
        super.init()
        
        // TODO check whether it's possible to do something similar as in android lib,
        //  with custom annotations and runtime map population
        mapping = [
            "call": call,
            "callPhoneNumber": callPhoneNumber,
            "hangup": hangup,
            "mute": mute,
            "speakerphone": speakerphone,
            "enablePushNotification": enablePushNotification,
            "handleIncomingCall": handleIncomingCall,
            "accept": accept,
            "decline": decline,
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

    
    public func emitEvent(event: String, data: Codable?) {
        callEventChannel.invokeMethod("onEvent", arguments: [
            "event": event,
            "data": data?.toJsonString()
        ])
    }
    
    
    /* SDK API */
    public func call(_ methodCall: FlutterMethodCall, result: @escaping FlutterResult) throws {
        let args = methodCall.arguments as! [String: Any]
        let token: String = args["token"] as! String
        let destination: String = args["destination"] as! String
        
        let infobipRTC: InfobipRTC = getInfobipRTCInstance()
        let callWebrtcRequest  = CallWebrtcRequest(token, destination: destination, webrtcCallEventListener: DefaultWebRTCCallEventListener(plugin: self)
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
        let token: String = args["token"] as! String
        let destination: String = args["destination"] as! String
        let infobipRTC: InfobipRTC = getInfobipRTCInstance()
        let callPhoneRequest = CallPhoneRequest(token, destination: destination,phoneCallEventListener: DefaultCallEventHandler(self))
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
        let infobipRTC: InfobipRTC = getInfobipRTCInstance()
        infobipRTC.getActiveCall()?.hangup()
        result(nil)
    }
    
    public func mute(_ methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = methodCall.arguments as! [String: Any]
        let mute: Bool = args["mute"] as! Bool
        let infobipRTC: InfobipRTC = getInfobipRTCInstance()
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
        let infobipRTC: InfobipRTC = getInfobipRTCInstance()

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
    
    public func enablePushNotification(_ methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        // todo
    }
    
    public func handleIncomingCall(_ methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        // todo
    }
    
    public func accept(_ methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        // todo
    }
    
    public func decline(_ methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        let infobipRTC: InfobipRTC = getInfobipRTCInstance()
        let incomingCall = infobipRTC.getActiveCall() as? IncomingCall
        incomingCall?.decline()
        result(nil)
    }
}
