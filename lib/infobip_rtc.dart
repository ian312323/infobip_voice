import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

import 'model/calls.dart';
import 'model/options.dart';
import 'model/requests.dart';

class InfobipRTC {
  static InfobipRTC? _infobipRTC;
  static InfobipRTC get _instance => _infobipRTC ??= InfobipRTC._internal();

  final MethodChannel _channel = const MethodChannel('infobip_webrtc_sdk_flutter');

  /// A reference to the ongoing call.
  static Call? _activeCall;

  static Call? get activeCall => _activeCall;

  InfobipRTC._internal() {
    _channel.setMethodCallHandler(_onMethodCall);
  }

  Future<void> _onMethodCall(MethodCall call) {
    throw Exception("No method on RTC SDK ${call.method}");
  }

  /* SDK Public API */
  /// Makes an outgoing call specified by [callRequest] to another user of Infobip's WebRTC platform.
  ///
  /// Additional call [options] can be optionally specified.
  static Future<OutgoingCall> call({required CallRequest callRequest, CallOptions? options}) async {
    String res = await _instance._channel.invokeMethod('call', {
      "token": callRequest.token,
      "destination": callRequest.destination,
      "options": options != null ? jsonEncode(options.toJson()) : null
    });
    _activeCall = OutgoingCall.fromJson(jsonDecode(res));
    activeCall?.callEventListener = callRequest.callEventListener;
    return activeCall as OutgoingCall;
  }

  /// Make a call to the conversations platform, specified by [callConversationsRequest].
  ///
  /// Additional call [options] can be optionally specified.
  static Future<OutgoingCall> callConversations(CallConversationsRequest callConversationsRequest,
      [CallOptions? options]) async {
    String jsonStr = await _instance._channel.invokeMethod('callConversations', {
      "token": callConversationsRequest.token,
      "options": options != null ? jsonEncode(options.toJson()) : null,
    });
    _activeCall = OutgoingCall.fromJson(jsonDecode(jsonStr));
    activeCall?.callEventListener = callConversationsRequest.callEventListener;
    return activeCall as OutgoingCall;
  }

  /// Make a call towards a phone number, specified with [callRequest].
  ///
  /// Additional call [options] can be optionally specified.
  static Future<OutgoingCall> callPhoneNumber({required CallRequest callRequest, CallOptions? options}) async {
    String jsonStr = await _instance._channel.invokeMethod('callPhoneNumber', {
      "token": callRequest.token,
      "destination": callRequest.destination,
    });

    _activeCall = OutgoingCall.fromJson(jsonDecode(jsonStr));
    activeCall?.callEventListener = callRequest.callEventListener;
    return activeCall as OutgoingCall;
  }
}
