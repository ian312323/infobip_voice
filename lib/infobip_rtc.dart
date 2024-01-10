import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:infobip_voice/model/errors.dart';

import 'model/calls.dart';
import 'model/options.dart';
import 'model/requests.dart';

class InfobipRTC {
  static InfobipRTC? _infobipRTC;

  static InfobipRTC get instance => _infobipRTC ??= InfobipRTC._internal();

  final MethodChannel _channel = const MethodChannel('infobip_webrtc_sdk_flutter');

  static const String _apiBaseUrl = "https://api.infobip.com";

  late final Dio _dio = Dio()..options.baseUrl = _apiBaseUrl;

  /// A reference to the ongoing call.
  static Call? _activeCall;

  static String? _token;

  String? get token => _token;

  bool get isLoggedIn => _token != null;

  static Call? get activeCall => _activeCall;

  InfobipRTC._internal() {
    _channel.setMethodCallHandler(_onMethodCall);
  }

  Future<void> _onMethodCall(MethodCall call) {
    throw Exception("No method on RTC SDK ${call.method}");
  }

  /* SDK Public API */

  // Login
  Future<void> registerClient({
    required String apiKey,
    required String identity,
    required String applicationId,
    required String displayName,
  }) async {
    try {
      final response = await _dio.post('/webrtc/1/token',
          data: {
            "identity": identity,
            "applicationId": applicationId,
            "displayName": displayName,
          },
          options: Options(
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'App $apiKey',
            },
          ));
      if (response.statusCode != 200) {
        throw TokenRegistrationError(message: '${response.statusCode}:${response.statusMessage}');
      }
      _token = response.data['token'];
    } catch (e) {
      throw TokenRegistrationError(message: e.toString());
    }
  }

  Future<void> unregisterClient() async {
    _token = null;
  }

  /// Makes an outgoing call specified by [callRequest] to another user of Infobip's WebRTC platform.
  ///
  /// Additional call [options] can be optionally specified.
  static Future<OutgoingCall> call({required CallRequest callRequest, CallOptions? options}) async {
    if (_token == null) throw const NoTokenError();
    if (callRequest.destination.isEmpty) throw const NoDestinationError();

    String res = await instance._channel.invokeMethod('call', {
      "token": _token,
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
    if (_token == null) throw const NoTokenError();

    String jsonStr = await instance._channel.invokeMethod('callConversations', {
      "token": _token,
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
    if (_token == null) throw const NoTokenError();
    if (callRequest.destination.isEmpty) throw const NoDestinationError();

    String jsonStr = await instance._channel.invokeMethod('callPhoneNumber', {
      "token": _token,
      "destination": callRequest.destination,
    });

    _activeCall = OutgoingCall.fromJson(jsonDecode(jsonStr));
    activeCall?.callEventListener = callRequest.callEventListener;
    return activeCall as OutgoingCall;
  }
}
