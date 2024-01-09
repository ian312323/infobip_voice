package com.infobip.infobip_webrtc_sdk_flutter.video

import android.content.Context
import com.infobip.infobip_webrtc_sdk_flutter.InfobipPlugin
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory


class RTCVideoViewFactory(private val plugin: InfobipPlugin) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
  override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
    val creationParams = args as Map<String?, Any?>?

    if (creationParams?.containsKey("streamId") != true) {
      throw IllegalArgumentException("streamId in RTCVideoView has to be set!")
    }

    val streamId = creationParams["streamId"] as String
    val view = RTCVideoViewManager(context, viewId, creationParams)
    plugin.setView(streamId, view.view as RTCVideoView)

    return view
  }
}

