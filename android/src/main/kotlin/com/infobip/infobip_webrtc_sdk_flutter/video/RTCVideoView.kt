package com.infobip.infobip_webrtc_sdk_flutter.video

import android.content.Context
import android.graphics.PixelFormat
import android.widget.FrameLayout
import com.infobip.webrtc.sdk.api.InfobipRTC
import com.infobip.webrtc.sdk.api.model.video.RTCVideoTrack
import com.infobip.webrtc.sdk.api.model.video.VideoRenderer
import org.webrtc.RendererCommon


class RTCVideoView(context: Context) : FrameLayout(context) {

  private var renderer: VideoRenderer = VideoRenderer(context)

  init {
    renderer.keepScreenOn = true
    renderer.setScalingType(RendererCommon.ScalingType.SCALE_ASPECT_FIT)
    renderer.init()
    renderer.setMirror(true)
    renderer.setZOrderMediaOverlay(true)
    renderer.setEnableHardwareScaler(true)

    addView(renderer)
  }

  fun attachTrack(id: String) {
//    val track = getTrack(id)
//    track?.addSink(renderer)
  }

  fun attachTrack(track: RTCVideoTrack?) {
    track?.addSink(renderer)
  }

  fun release() {
    renderer.release()
  }

//  private fun getTrack(id: String): RTCVideoTrack? {
//    val activeCall = InfobipRTC.getInstance().activeCall ?: return null
//
//    return when (id) {
//      "local" -> activeCall.lo
//      "remote" -> activeCall.remoteVideoTrack()
//      else -> null
//    }
//  }
}
