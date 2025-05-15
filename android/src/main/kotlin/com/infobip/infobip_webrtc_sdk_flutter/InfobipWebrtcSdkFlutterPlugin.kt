package com.infobip.infobip_webrtc_sdk_flutter

import android.app.Activity
import android.content.Context
import android.os.Build
import android.util.Log
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import com.infobip.infobip_webrtc_sdk_flutter.util.ObjectSerializer
import com.infobip.infobip_webrtc_sdk_flutter.video.RTCVideoView
import com.infobip.infobip_webrtc_sdk_flutter.video.RTCVideoViewFactory
import com.infobip.webrtc.sdk.api.InfobipRTC
import com.infobip.webrtc.sdk.api.call.*
import com.infobip.webrtc.sdk.api.event.listener.IncomingCallEventListener
import com.infobip.webrtc.sdk.api.model.video.RTCVideoTrack
import com.infobip.webrtc.sdk.api.options.WebrtcCallOptions
import com.infobip.webrtc.sdk.api.request.CallPhoneRequest
import com.infobip.webrtc.sdk.api.request.CallWebrtcRequest
import com.infobip.webrtc.sdk.impl.event.listener.DefaultWebrtcCallEventListener
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.ref.WeakReference
import java.lang.reflect.Method
import java.util.*


typealias ApiMapping = (MethodCall, Result) -> Unit

/** InfobipWebrtcSdkFlutterPlugin */
class InfobipWebrtcSdkFlutterPlugin : FlutterPlugin, ActivityAware, MethodCallHandler,
    InfobipPlugin {
    private lateinit var channel: MethodChannel
    private lateinit var callEventChannel: MethodChannel
    private lateinit var incomingCallEventChannel: MethodChannel

    private var token: String? = null
    private var pushId: String? = null

    private val activity get() = activityReference.get()
    private val applicationContext
        get() = contextReference.get() ?: activity?.applicationContext

    private val serializer = ObjectSerializer()

    private var activityReference = WeakReference<Activity>(null)
    private var contextReference = WeakReference<Context>(null)

    private var apiMapping: MutableMap<String, ApiMapping> = mutableMapOf()

    private var infobipRTC: InfobipRTC = InfobipRTC.getInstance()
    private var incomingCall: IncomingCall? = null

    private val views: MutableMap<String, RTCVideoView> = HashMap()

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityReference = WeakReference(binding.activity)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityReference.clear()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activityReference = WeakReference(binding.activity)
    }

    override fun onDetachedFromActivity() {
        activityReference.clear()
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "infobip_webrtc_sdk_flutter")
        channel.setMethodCallHandler(this)

        callEventChannel = MethodChannel(
            flutterPluginBinding.binaryMessenger, "infobip_webrtc_sdk_flutter_call_event"
        )

        incomingCallEventChannel = MethodChannel(
            flutterPluginBinding.binaryMessenger, "infobip_webrtc_sdk_flutter_incoming_call"
        )

        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            "<infobip-rtc-video-view>",
            RTCVideoViewFactory(this)
        )

        // Store the application context
        contextReference = WeakReference(flutterPluginBinding.applicationContext)

        InfobipWebrtcSdkFlutterPlugin::class.java.methods.filter { e ->
            e.isAnnotationPresent(
                FlutterApi::class.java
            )
        }.forEach { method ->
            apiMapping[method.name] = invokeApiMethod(method)
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        val mapping = apiMapping[call.method];
        if (mapping != null) {
            mapping(call, result);
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        callEventChannel.setMethodCallHandler(null)
    }

    private fun invokeApiMethod(method: Method): ApiMapping {
        return { methodCall: MethodCall, result: Result ->
            try {
                result.success(method.invoke(this, methodCall))
            } catch (ex: Throwable) {
                val cause = ex.cause ?: ex
                Log.e("WebRTC", "Error invoking method ${method.name}", cause)
                result.error(
                    "ERROR",
                    "Error in ${method.name}: ${cause.message}",
                    cause.stackTraceToString()
                )
            }
        }
    }

    private fun validateContext(): Boolean {
        if (applicationContext == null) {
            Log.e("WebRTC", "Application context is null. Plugin may not be properly initialized.")
            return false
        }
        return true
    }

    override fun setView(streamId: String, rtcVideoView: RTCVideoView) {
        views[streamId] = rtcVideoView
        if (Objects.equals(streamId, "remote")) {
//            rtcVideoView.attachTrack(InfobipRTC.getActiveCall()?.remoteVideoTrack())
        } else {
//            rtcVideoView.attachTrack(infobipRTC.activeCall?.vi)
        }
    }

    override fun setTrack(streamId: String, track: RTCVideoTrack?) {
        track?.let {
            views[streamId]?.attachTrack(it)
        }
    }

    override fun clearViews() {
        views.values.forEach {
            it.release()
        }
        return views.clear()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun emitEvent(event: String, data: Map<String, Any?>?) {
        activity?.runOnUiThread {
            val map =
                mapOf("event" to event, "data" to data?.let { serializer.serializeToString(it) })
            callEventChannel.invokeMethod("onEvent", map)
        }
    }

    @FlutterApi
    fun setToken(methodCall: MethodCall): String {
        if (!validateContext()) {
            throw IllegalStateException("Application context is not available. Plugin may not be properly initialized.")
        }

        val newToken = methodCall.argument<String>("token")
        val newPushId = methodCall.argument<String>("pushConfigId")
        
        if (newToken == null) {
            Log.e("WebRTC", "Token argument is missing")
            throw IllegalArgumentException("Token argument is required")
        }
        
    
        token = newToken
        pushId = newPushId
        Log.d("WebRTC", "Token and PushConfigId set successfully")
        return ""
    }

    /* SDK API */
    @RequiresApi(Build.VERSION_CODES.O)
    @FlutterApi
    fun call(methodCall: MethodCall): String {
        if (token == null) return ""

        val destination: String = methodCall.argument("destination")!!
        val options: WebrtcCallOptions? = methodCall.argument<String?>("options")
            ?.let { serializer.fromJson(it, WebrtcCallOptions::class.java) }

        val callRequest = CallWebrtcRequest(
            token!!,
            applicationContext!!,
            destination,
            DefaultWebrtcCallEventListener(),
        )
        val webrtcCallOptions = WebrtcCallOptions.builder().video(false).build()

        try {
            val call: WebrtcCall = infobipRTC.callWebrtc(callRequest, options ?: webrtcCallOptions)

            return serializer.serializeToString(call)!!
        } catch (e: Exception) {
            Log.d("RTC", e.message, e)
            throw e
        }
    }


    @RequiresApi(Build.VERSION_CODES.O)
    @FlutterApi
    fun callPhoneNumber(methodCall: MethodCall): String {
        val destination: String = methodCall.argument("destination")!!
        if (token == null) {
            return ""
        }

        val callRequest = CallPhoneRequest(
            token!!, applicationContext!!, destination, DefaultCallEventListener(this)
        )

        val call: PhoneCall = infobipRTC.callPhone(callRequest)
        return serializer.serializeToString(call)!!
    }

//  @FlutterApi
//  fun callConversations(methodCall: MethodCall): String {
//    val token: String = methodCall.argument("token")!!
//    val options: CallOptions? = methodCall.argument<String?>("options")?.let { serializer.fromJson(it, CallOptions::class.java) }
//
//
//    val callRequest =
//      CallConversationsRequest(token, applicationContext, DefaultCallEventListener(this))
//    try {
//      val call: OutgoingCall = InfobipRTC.callConversations(callRequest, options ?: CallOptions.builder().build())
//      attachEventListener(call)
//      return serializer.serializeToString(call)!!
//    } catch (e: Exception) {
//      Log.d("RTC", e.message, e)
//      throw e
//    }
//}

//  @FlutterApi
//  fun callSIP(methodCall: MethodCall): String {
//    val token: String = methodCall.argument("token")!!
//    val destination: String = methodCall.argument("destination")!!
//    val options: CallOptions? = methodCall.argument<String?>("options")?.let { serializer.fromJson(it, CallOptions::class.java) }
//
//
//    val callRequest = CallRequest(token, applicationContext, destination, DefaultCallEventListener(this))
//    try {
//      val call: OutgoingCall = infobipRTC.call(callRequest, options ?: CallOptions.builder().build())
//      attachEventListener(call)
//      return serializer.serializeToString(call)!!
//    } catch (e: Exception) {
//      Log.d("RTC", e.message, e)
//      throw e
//    }
//  }

    @FlutterApi
    fun hangup(methodCall: MethodCall) {
        infobipRTC.activeCall.hangup()
    }

    @FlutterApi
    fun mute(methodCall: MethodCall) {
        val mute: Boolean = methodCall.argument("mute")!!
        infobipRTC.activeCall.mute(mute)
    }

    @FlutterApi
    fun speakerphone(methodCall: MethodCall) {
        val enabled: Boolean = methodCall.argument("enabled")!!
        infobipRTC.activeCall.speakerphone(enabled)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    @FlutterApi
    fun handleIncomingCalls(methodCall: MethodCall) {
        if (!validateContext()) {
            throw IllegalStateException("Application context is not available. Plugin may not be properly initialized.")
        }

        if (token == null) {
            Log.e("WebRTC", "Token is null. Please set token before handling incoming calls.")
            return
        }

        try {
            infobipRTC.registerForActiveConnection(
                token!!, applicationContext!!,
                IncomingCallEventListener { incomingWebrtcCallEvent ->
                    val incomingWebrtcCall = incomingWebrtcCallEvent.incomingWebrtcCall
                    Log.d(
                        "WebRTC",
                        "Received incoming call from:  " + incomingWebrtcCall.source()
                            .identifier() + " " + incomingWebrtcCall.source().displayIdentifier()
                    )
                    incomingWebrtcCall.eventListener = DefaultWebRTCCallEventListener(this)
                    incomingCall  = incomingWebrtcCall
                    activity?.runOnUiThread {
                        val map =
                            mapOf(
                                "event" to "onIncomingCall",
                                "data" to incomingWebrtcCall.let { serializer.serializeToString(it)!! },
                            )
                        incomingCallEventChannel.invokeMethod("onEvent", map)
                    }
                },
            )
        } catch (e: Exception) {
            Log.e("WebRTC", "Error registering for active connection", e)
            throw e
        }
    }

    @FlutterApi
    fun accept(methodCall: MethodCall) {
        if(incomingCall == null) return
        Log.d("accepting incoming call", "Destination" + incomingCall?.destination())
        incomingCall?.accept()
    }

    @FlutterApi
    fun decline(methodCall: MethodCall) {
        if(incomingCall == null) return
        Log.d("accepting incoming call", "Destination" + incomingCall?.destination())
        incomingCall?.decline()
    }
}
