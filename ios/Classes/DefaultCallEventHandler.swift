import Flutter
import UIKit
import Foundation
import InfobipRTC


class DefaultCallEventHandler : PhoneCallEventListener {
    let plugin: InfobipPlugin
    
    init(_ plugin: InfobipPlugin) {
        self.plugin = plugin
    }
    
    func onRinging(_ callRingingEvent: CallRingingEvent) {
        plugin.emitEvent(event: "ringing", data: nil)
    }
    
    func onEarlyMedia(_ callEarlyMediaEvent: CallEarlyMediaEvent) {
        plugin.emitEvent(event: "early-media", data: nil)
    }
    
    func onEstablished(_ callEstablishedEvent: CallEstablishedEvent) {
        plugin.emitEvent(event: "established", data: FlutterModel.CallEstablishedEvent(
            hasLocalVideo: false,
            hasRemoteVideo: false
        ))
    }
    
    func onHangup(_ callHangupEvent: CallHangupEvent) {
        plugin.clearViews()
        plugin.emitEvent(event: "hangup", data: FlutterModel.CallHangupEvent(
            id: callHangupEvent.errorCode.id,
            name: callHangupEvent.errorCode.name,
            description: callHangupEvent.errorCode.description
        ))
    }
    
    func onError(_ callErrorEvent: ErrorEvent) {
        plugin.clearViews()
        plugin.emitEvent(event: "error", data: FlutterModel.CallErrorEvent(
            name: callErrorEvent.errorCode.name,
            description: callErrorEvent.errorCode.description
        ))
    }
}


class DefaultWebRTCCallEventListener: WebrtcCallEventListener{
    let plugin: InfobipPlugin
    
    init(plugin: InfobipPlugin) {
        self.plugin = plugin
    }
    
    func onCameraVideoAdded(_ cameraVideoAddedEvent: CameraVideoAddedEvent) {
        
    }
    
    func onCameraVideoUpdated(_ cameraVideoUpdatedEvent: CameraVideoUpdatedEvent) {
        
    }
    
    func onCameraVideoRemoved() {
        
    }
    
    func onScreenShareAdded(_ screenShareAddedEvent: ScreenShareAddedEvent) {
        
    }
    
    func onScreenShareRemoved(_ screenShareRemovedEvent: ScreenShareRemovedEvent) {
        
    }
    
    func onRemoteCameraVideoAdded(_ cameraVideoAddedEvent: CameraVideoAddedEvent) {
        
    }
    
    func onRemoteCameraVideoRemoved() {
        
    }
    
    func onRemoteScreenShareAdded(_ screenShareAddedEvent: ScreenShareAddedEvent) {
        
    }
    
    func onRemoteScreenShareRemoved() {
        
    }
    
    func onRemoteMuted() {
        
    }
    
    func onRemoteUnmuted() {
        plugin.emitEvent(event: "remote_unmuted", data: nil)
    }
    
    func onRinging(_ callRingingEvent: CallRingingEvent) {
        plugin.emitEvent(event: "ringing", data: nil)
    }
    
    func onEarlyMedia(_ callEarlyMediaEvent: CallEarlyMediaEvent) {
        plugin.emitEvent(event: "early-media", data: nil)
    }
    
    func onEstablished(_ callEstablishedEvent: CallEstablishedEvent) {
        plugin.emitEvent(event: "established", data: FlutterModel.CallEstablishedEvent(
            hasLocalVideo: false,
            hasRemoteVideo: false
        ))
    }
    
    func onHangup(_ callHangupEvent: CallHangupEvent) {
        plugin.clearViews()
        plugin.emitEvent(event: "hangup", data: FlutterModel.CallHangupEvent(id: callHangupEvent.errorCode.id, name: callHangupEvent.errorCode.name, description: callHangupEvent.errorCode.description))
    }
    
    func onError(_ errorEvent: ErrorEvent) {
        plugin.clearViews()
        plugin.emitEvent(event: "error", data: FlutterModel.CallErrorEvent(
            name: errorEvent.errorCode.name,
            description: errorEvent.errorCode.description
        ))
    }
}
