package com.infobip.infobip_webrtc_sdk_flutter

import com.infobip.infobip_webrtc_sdk_flutter.video.RTCVideoView
import com.infobip.webrtc.sdk.api.model.video.RTCVideoTrack

interface InfobipPlugin {
    fun setView(streamId: String, rtcVideoView: RTCVideoView)
    fun setTrack(streamId: String, track: RTCVideoTrack?)
    fun clearViews()
    fun emitEvent(event: String, data: Map<String, Any?>?)
}