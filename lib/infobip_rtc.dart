import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:infobip_voice/model/errors.dart';

import 'model/calls.dart';
import 'model/options.dart';
import 'model/requests.dart';

class InfobipRTC {
  static InfobipRTC? _infobipRTC;

  static const String _apiBaseUrl = "https://api.infobip.com";

  /// A reference to the ongoing call.
  static Call? _activeCall;
  static String? _token;

  static Call? get activeCall => _activeCall;

  static InfobipRTC get instance => _infobipRTC ??= InfobipRTC._internal();

  final MethodChannel _channel = const MethodChannel('infobip_webrtc_sdk_flutter');

  final MethodChannel _incomingChannel = const MethodChannel('infobip_webrtc_sdk_flutter_incoming_call');

  late final Dio _dio = Dio()..options.baseUrl = _apiBaseUrl;

  InfobipRTC._internal() {
    _channel.setMethodCallHandler(_onMethodCall);
  }

  bool get isLoggedIn => _token != null;

  String? get token => _token;

  /* SDK Public API */

  // * [registerClient] registers the client to the Infobip WebRTC platform.
  // * [apiKey] is the API key of the application.
  // * [identity] is the identity of the user.
  // * [applicationId] is the ID of the application.
  // * [displayName] is the display name of the user.
  // pushConfigId is the ID of the push configuration. Only iOS
  // Android uses active connection for calls, so push configuration is not needed.
  Future<void> registerClient({
    required String apiKey,
    required String identity,
    required String applicationId,
    required String displayName,
    String? pushConfigId,
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

      await instance._channel.invokeMethod('setToken', {
        "token": _token,
        "pushConfigId": pushConfigId,
      });
      if (Platform.isAndroid) {
        await instance._channel.invokeMethod('handleIncomingCalls');
      }
    } catch (e) {
      throw TokenRegistrationError(message: e.toString());
    }
  }

  // Only use if you are handling your own token
  Future<void> setToken(String token, {String? pushConfigId}) async {
    _token = token;

    await instance._channel.invokeMethod('setToken', {
      "token": _token,
      "pushConfigId": pushConfigId,
    });
    if (Platform.isAndroid) {
      await instance._channel.invokeMethod('handleIncomingCalls');
    }
  }

  Future<void> unregisterClient() async {
    _token = null;
  }

  Future<void> _onMethodCall(MethodCall call) {
    throw Exception("No method on RTC SDK ${call.method}");
  }

  /// Makes an outgoing call specified by [callRequest] to another user of Infobip's WebRTC platform.
  ///
  /// Additional call [options] can be optionally specified.
  static Future<OutgoingCall> call({required CallRequest callRequest, CallOptions? options}) async {
    if (_token == null) throw const NoTokenError();
    if (callRequest.destination.isEmpty) throw const NoDestinationError();

    String res = await instance._channel.invokeMethod('call',
        {"destination": callRequest.destination, "options": options != null ? jsonEncode(options.toJson()) : null});

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
      "destination": callRequest.destination,
    });

    _activeCall = OutgoingCall.fromJson(jsonDecode(jsonStr));
    activeCall?.callEventListener = callRequest.callEventListener;
    return activeCall as OutgoingCall;
  }

  static Future<void> handleIncomingCalls(Function(IncomingCall) onCall) async {
    instance._incomingChannel.setMethodCallHandler((call) async {
      if (call.method == 'onEvent') {
        final event = call.arguments['event'];
        switch (event) {
          case "onIncomingCall":
            final callData = jsonDecode(call.arguments['data'].toString()) as Map<String, dynamic>;
            _activeCall = IncomingCall.fromJson(callData);
            onCall.call(_activeCall as IncomingCall);
            break;
          default:
            throw Exception("Unknown call event! ${call.method}");
        }
      }
    });
  }
}
