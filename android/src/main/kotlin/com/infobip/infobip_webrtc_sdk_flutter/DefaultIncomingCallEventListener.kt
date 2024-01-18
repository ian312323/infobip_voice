package com.infobip.infobip_webrtc_sdk_flutter



import com.infobip.webrtc.sdk.api.event.listener.IncomingCallEventListener
import com.infobip.webrtc.sdk.api.event.rtc.IncomingWebrtcCallEvent
import com.infobip.webrtc.sdk.impl.event.listener.DefaultWebrtcCallEventListener
import io.flutter.plugin.common.MethodChannel

class DefaultIncomingCallEventListener(private val plugin: InfobipPlugin) : IncomingCallEventListener {

    override fun onIncomingWebrtcCall(incomingWebrtcCallEvent: IncomingWebrtcCallEvent?) {
        incomingWebrtcCallEvent?.incomingWebrtcCall?.eventListener = DefaultWebrtcCallEventListener()
    }
}
