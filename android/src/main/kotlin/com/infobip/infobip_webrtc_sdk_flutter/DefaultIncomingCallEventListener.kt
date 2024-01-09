package com.infobip.infobip_webrtc_sdk_flutter


import com.infobip.webrtc.sdk.api.event.IncomingCallEventListener
import com.infobip.webrtc.sdk.api.event.rtc.IncomingCallEvent
import io.flutter.plugin.common.MethodChannel

class DefaultIncomingCallEventListener(private val plugin: InfobipPlugin) : IncomingCallEventListener {

    override fun onIncomingCall(incomingCallEvent: IncomingCallEvent?) {
        incomingCallEvent?.incomingCall?.setEventListener(DefaultCallEventListener(plugin))
        // TODO promise.resolve(payload)
    }
}
