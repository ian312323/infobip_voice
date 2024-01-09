package com.infobip.infobip_webrtc_sdk_flutter

import com.infobip.webrtc.sdk.api.ErrorCode
import com.infobip.webrtc.sdk.api.event.CallEventListener
import com.infobip.webrtc.sdk.api.event.call.*
import com.infobip.webrtc.sdk.api.video.RTCVideoTrack

class DefaultCallEventListener(
  private val plugin : InfobipPlugin
) : CallEventListener {
  override fun onHangup(callHangupEvent: CallHangupEvent?) {
    val errorCode = callHangupEvent?.errorCode?:ErrorCode.EC_WEBRTC_ERROR
    val hangupReason = getHangupReason(errorCode)
    plugin.clearViews()
    emitEvent("hangup", hangupReason)
  }

  override fun onEstablished(callEstablishedEvent: CallEstablishedEvent?) {
    val hasLocalVideo = callEstablishedEvent?.localRTCVideoTrack != null
    val hasRemoteVideo = callEstablishedEvent?.remoteRTCVideoTrack != null
    val eventData = getEventData(hasLocalVideo, hasRemoteVideo)
    attachVideoTracks(callEstablishedEvent?.remoteRTCVideoTrack, callEstablishedEvent?.localRTCVideoTrack)
    emitEvent("established", eventData)
  }

  override fun onEarlyMedia(callEarlyMediaEvent: CallEarlyMediaEvent?) {
    emitEvent("early-media")
  }

  override fun onUpdated(callUpdatedEvent: CallUpdatedEvent?) {
    val hasLocalVideo = callUpdatedEvent?.localRTCVideoTrack != null
    val hasRemoteVideo = callUpdatedEvent?.remoteRTCVideoTrack != null
    val eventData = getEventData(hasLocalVideo, hasRemoteVideo)
    attachVideoTracks(callUpdatedEvent?.remoteRTCVideoTrack, callUpdatedEvent?.localRTCVideoTrack)
    emitEvent("updated", eventData)
  }

  override fun onError(callErrorEvent: CallErrorEvent?) {
    val errorCode = callErrorEvent?.reason?:ErrorCode.EC_WEBRTC_ERROR
    val hangupReason = getHangupReason(errorCode)
    plugin.clearViews()
    emitEvent("error", hangupReason)
  }

  override fun onRinging(callRingingEvent: CallRingingEvent?) {
    emitEvent("ringing")
  }

  private fun attachVideoTracks(remoteVideoTrack: RTCVideoTrack?, localVideoTrack: RTCVideoTrack?) {
    plugin.setTrack("remote", remoteVideoTrack)
    plugin.setTrack("local", localVideoTrack)
  }

  private fun emitEvent(event: String) {
    plugin.emitEvent(event, null)
  }

  private fun emitEvent(event: String, data: Map<String, Any?>) {
    plugin.emitEvent(event, data)
  }

  private fun getEventData(hasLocalVideo: Boolean, hasRemoteVideo: Boolean): MutableMap<String, Any> {
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
