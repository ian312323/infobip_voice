package com.infobip.infobip_webrtc_sdk_flutter

import com.infobip.webrtc.sdk.api.event.call.*
import com.infobip.webrtc.sdk.api.event.listener.PhoneCallEventListener
import com.infobip.webrtc.sdk.api.event.listener.WebrtcCallEventListener
import com.infobip.webrtc.sdk.api.model.ErrorCode
import com.infobip.webrtc.sdk.impl.event.listener.DefaultWebrtcCallEventListener


class DefaultCallEventListener(
    private val plugin: InfobipPlugin
) : PhoneCallEventListener {
    override fun onHangup(callHangupEvent: CallHangupEvent?) {
        val errorCode = callHangupEvent?.errorCode ?: ErrorCode.NORMAL_HANGUP
        val hangupReason = getHangupReason(errorCode)
        plugin.clearViews()
        emitEvent("hangup", hangupReason)
    }

    override fun onEstablished(callEstablishedEvent: CallEstablishedEvent) {
        val hasLocalVideo = false
        val hasRemoteVideo = false
        val eventData = getEventData(hasLocalVideo, hasRemoteVideo)
//        attachVideoTracks(
//            callEstablishedEvent?.remoteRTCVideoTrack,
//            callEstablishedEvent?.localRTCVideoTrack
//        )
        emitEvent("established", eventData)
    }

    override fun onEarlyMedia(callEarlyMediaEvent: CallEarlyMediaEvent?) {
        emitEvent("early-media")
    }

    override fun onError(callErrorEvent: ErrorEvent) {
        val errorCode = callErrorEvent?.errorCode ?: ErrorCode.UNKNOWN
        val hangupReason = getHangupReason(errorCode)
        plugin.clearViews()
        emitEvent("error", hangupReason)
    }

    override fun onRinging(callRingingEvent: CallRingingEvent?) {
        emitEvent("ringing")
    }

    private fun emitEvent(event: String) {
        plugin.emitEvent(event, null)
    }

    private fun emitEvent(event: String, data: Map<String, Any?>) {
        plugin.emitEvent(event, data)
    }

    private fun getEventData(
        hasLocalVideo: Boolean,
        hasRemoteVideo: Boolean
    ): MutableMap<String, Any> {
        val eventData = mutableMapOf<String, Any>()
        eventData["hasLocalVideo"] = hasLocalVideo
        eventData["hasRemoteVideo"] = hasRemoteVideo
        return eventData
    }

    private fun getHangupReason(errorCode: ErrorCode): MutableMap<String, Any> {
        val hangupReason = mutableMapOf<String, Any>()
        hangupReason["id"] = errorCode.id
        hangupReason["name"] = errorCode.name
        hangupReason["description"] = errorCode.description
        return hangupReason
    }

}

class DefaultWebRTCCallEventListener(private val plugin: InfobipPlugin) : DefaultWebrtcCallEventListener() {
    override fun onHangup(callHangupEvent: CallHangupEvent?) {
        val errorCode = callHangupEvent?.errorCode ?: ErrorCode.NORMAL_HANGUP
        val hangupReason = getHangupReason(errorCode)
        plugin.clearViews()
        emitEvent("hangup", hangupReason)
    }

    override fun onEstablished(callEstablishedEvent: CallEstablishedEvent) {
        val hasLocalVideo = false
        val hasRemoteVideo = false
        val eventData = getEventData(hasLocalVideo, hasRemoteVideo)
//        attachVideoTracks(
//            callEstablishedEvent?.remoteRTCVideoTrack,
//            callEstablishedEvent?.localRTCVideoTrack
//        )
        emitEvent("established", eventData)
    }

    override fun onEarlyMedia(callEarlyMediaEvent: CallEarlyMediaEvent?) {
        emitEvent("early-media")
    }

    override fun onError(callErrorEvent: ErrorEvent) {
        val errorCode = callErrorEvent?.errorCode ?: ErrorCode.UNKNOWN
        val hangupReason = getHangupReason(errorCode)
        plugin.clearViews()
        emitEvent("error", hangupReason)
    }


    override fun onRinging(callRingingEvent: CallRingingEvent?) {
        emitEvent("ringing")
    }

    private fun emitEvent(event: String) {
        plugin.emitEvent(event, null)
    }

    private fun emitEvent(event: String, data: Map<String, Any?>) {
        plugin.emitEvent(event, data)
    }

    private fun getEventData(
        hasLocalVideo: Boolean,
        hasRemoteVideo: Boolean
    ): MutableMap<String, Any> {
        val eventData = mutableMapOf<String, Any>()
        eventData["hasLocalVideo"] = hasLocalVideo
        eventData["hasRemoteVideo"] = hasRemoteVideo
        return eventData
    }

    private fun getHangupReason(errorCode: ErrorCode): MutableMap<String, Any> {
        val hangupReason = mutableMapOf<String, Any>()
        hangupReason["id"] = errorCode.id
        hangupReason["name"] = errorCode.name
        hangupReason["description"] = errorCode.description
        return hangupReason
    }

}