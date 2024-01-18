package com.infobip.infobip_webrtc_sdk_flutter

import com.infobip.webrtc.sdk.api.event.listener.EventListener
import com.infobip.webrtc.sdk.api.model.push.EnablePushNotificationResult

class DefaultEventListener : EventListener<EnablePushNotificationResult> {

    override fun onEvent(data: EnablePushNotificationResult?) {
//        println(data.)
    }
}
