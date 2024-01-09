package com.infobip.infobip_webrtc_sdk_flutter

import com.infobip.webrtc.sdk.api.event.EventListener
import com.infobip.webrtc.sdk.api.event.rtc.EnablePushNotificationResult

class DefaultEventListener : EventListener<EnablePushNotificationResult> {

    override fun onEvent(data: EnablePushNotificationResult?) {
        // todo
    }
}
