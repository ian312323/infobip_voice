package com.infobip.infobip_webrtc_sdk_flutter

import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.infobip.infobip_webrtc_sdk_flutter.util.ObjectSerializer
import com.infobip.infobip_webrtc_sdk_flutter.video.RTCVideoView
import com.infobip.infobip_webrtc_sdk_flutter.video.RTCVideoViewFactory
import com.infobip.webrtc.sdk.api.InfobipRTC
import com.infobip.webrtc.sdk.api.call.*
import com.infobip.webrtc.sdk.api.call.options.CallOptions
import com.infobip.webrtc.sdk.api.call.options.VideoOptions
import com.infobip.webrtc.sdk.api.video.RTCVideoTrack
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
class InfobipWebrtcSdkFlutterPlugin: FlutterPlugin, ActivityAware, MethodCallHandler, InfobipPlugin {
  private lateinit var channel : MethodChannel
  private lateinit var callEventChannel : MethodChannel

  private val activity get() = activityReference.get()
  private val applicationContext get() =
    contextReference.get() ?: activity?.applicationContext

  private val serializer = ObjectSerializer()

  private var activityReference = WeakReference<Activity>(null)
  private var contextReference = WeakReference<Context>(null)

  private var apiMapping : MutableMap<String, ApiMapping> = mutableMapOf()

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

    callEventChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "infobip_webrtc_sdk_flutter_call_event")

    flutterPluginBinding.platformViewRegistry
      .registerViewFactory("<infobip-rtc-video-view>", RTCVideoViewFactory(this))

    InfobipWebrtcSdkFlutterPlugin::class.java.methods
      .filter { e -> e.isAnnotationPresent(FlutterApi::class.java) }
      .forEach { method ->
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
    return { methodCall: MethodCall, result: Result -> try {
      result.success(method.invoke(this, methodCall))
    } catch (ex: Throwable) {
      // TODO better error handling
      result.error("ERROR", ex.message, ex);
    } }
  }


  override fun setView(streamId: String, rtcVideoView: RTCVideoView) {
    views[streamId] = rtcVideoView
    if (Objects.equals(streamId, "remote")) {
      rtcVideoView.attachTrack(InfobipRTC.getActiveCall()?.remoteVideoTrack())
    } else {
      rtcVideoView.attachTrack(InfobipRTC.getActiveCall()?.localVideoTrack())
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

  fun attachEventListener(call: Call) {
    call.setEventListener(DefaultCallEventListener(this))
  }

  override fun emitEvent(event: String, data: Map<String, Any?>?) {
    activity?.runOnUiThread {
      val map = mapOf(
        "event" to event,
        "data" to data?.let { serializer.serializeToString(it) }
      )
      callEventChannel.invokeMethod("onEvent", map)
    }
  }

  /* SDK API */
  @FlutterApi
  fun call(methodCall: MethodCall): String {
    val token: String = methodCall.argument("token")!!
    val destination: String = methodCall.argument("destination")!!
    val options: CallOptions? = methodCall.argument<String?>("options")?.let { serializer.fromJson(it, CallOptions::class.java) }
    val callRequest =
      CallRequest(token, applicationContext, destination, DefaultCallEventListener(this))
    try {
      val call: OutgoingCall = InfobipRTC.call(callRequest, options ?: CallOptions.builder().build())
      attachEventListener(call)
      return serializer.serializeToString(call)!!
    } catch (e: Exception) {
      Log.d("RTC", e.message, e)
      throw e
    }
  }


  @FlutterApi
  fun callPhoneNumber(methodCall: MethodCall): String {
    val token: String = methodCall.argument("token")!!
    val destination: String = methodCall.argument("destination")!!

    val callRequest =
      CallRequest(token, applicationContext, destination, DefaultCallEventListener(this))

    val call: OutgoingCall = InfobipRTC.callPhoneNumber(callRequest)
    attachEventListener(call)
    return serializer.serializeToString(call)!!
  }

  @FlutterApi
  fun callConversations(methodCall: MethodCall): String {
    val token: String = methodCall.argument("token")!!
    val options: CallOptions? = methodCall.argument<String?>("options")?.let { serializer.fromJson(it, CallOptions::class.java) }


    val callRequest =
      CallConversationsRequest(token, applicationContext, DefaultCallEventListener(this))
    try {
      val call: OutgoingCall = InfobipRTC.callConversations(callRequest, options ?: CallOptions.builder().build())
      attachEventListener(call)
      return serializer.serializeToString(call)!!
    } catch (e: Exception) {
      Log.d("RTC", e.message, e)
      throw e
    }
  }

  @FlutterApi
  fun callSIP(methodCall: MethodCall): String {
    val token: String = methodCall.argument("token")!!
    val destination: String = methodCall.argument("destination")!!
    val options: CallOptions? = methodCall.argument<String?>("options")?.let { serializer.fromJson(it, CallOptions::class.java) }


    val callRequest = CallRequest(token, applicationContext, destination, DefaultCallEventListener(this))
    try {
      val call: OutgoingCall = InfobipRTC.callSIP(callRequest, options ?: CallOptions.builder().build())
      attachEventListener(call)
      return serializer.serializeToString(call)!!
    } catch (e: Exception) {
      Log.d("RTC", e.message, e)
      throw e
    }
  }

  @FlutterApi
  fun hangup(methodCall: MethodCall) {
    InfobipRTC.getActiveCall()?.hangup()
  }

  @FlutterApi
  fun mute(methodCall: MethodCall) {
    val mute: Boolean = methodCall.argument("mute")!!
    InfobipRTC.getActiveCall()?.mute(mute)
  }

  @FlutterApi
  fun speakerphone(methodCall: MethodCall) {
    val enabled: Boolean = methodCall.argument("enabled")!!
    InfobipRTC.getActiveCall()?.speakerphone(enabled)
  }

  @FlutterApi
  fun localVideo(methodCall: MethodCall) {
    val localVideo: Boolean = methodCall.argument("localVideo")!!
    InfobipRTC.getActiveCall()?.localVideo(localVideo)
  }

  @FlutterApi
  fun cameraOrientation(methodCall: MethodCall): String {
    return InfobipRTC.getActiveCall()?.cameraOrientation()?.name!!
  }


  @FlutterApi
  fun setCameraOrientation(methodCall: MethodCall) {
    val str = methodCall.argument<String>("orientation")!!
    val orientation = VideoOptions.CameraOrientation.valueOf(str)
    InfobipRTC.getActiveCall()?.cameraOrientation(orientation)
  }

  @FlutterApi
  fun enablePushNotification(methodCall: MethodCall) {
    val token: String = methodCall.argument("token")!!
    val deviceToken: String = methodCall.argument("deviceToken")!!
    val debug: Boolean? = methodCall.argument("debug")

    InfobipRTC.enablePushNotification(token, applicationContext, DefaultEventListener())
  }

  @FlutterApi
  fun handleIncomingCall(methodCall: MethodCall) {
    val payload: Map<String, Any?> = methodCall.argument("payload")!!
    // todo
  }

  @FlutterApi
  fun accept(methodCall: MethodCall) {
    val options = methodCall.argument<Map<String, Any>?>("options")

    val incomingCall = InfobipRTC.getActiveCall()
    if (incomingCall != null) {
      if (options == null || options.isEmpty()) {
        (incomingCall as IncomingCall).accept()
      } else {
        val video: Boolean = options.get("_video") as Boolean
        val callOptions: CallOptions = CallOptions.builder().video(video).build()
        (incomingCall as IncomingCall).accept(callOptions)
      }
    }
  }

  @FlutterApi
  fun decline(methodCall: MethodCall) {
    val incomingCall = InfobipRTC.getActiveCall()
    if (incomingCall != null) {
      (incomingCall as IncomingCall).decline()
    }
  }
}
