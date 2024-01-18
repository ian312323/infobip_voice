import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:infobip_voice/api/listeners.dart';
import 'package:infobip_voice/model/events.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:developer' as developer;

import 'enums.dart';

part 'calls.g.dart';

@JsonSerializable()
class User {
  const User({
    required this.displayIdentifier,
    required this.identifier,
    required this.type,
  });

  final String? displayIdentifier;
  final String identifier;
  final String? type;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

DateTime customDateTimeFromString(String dateTime) {
  return DateTime.parse(dateTime.replaceFirstMapped(RegExp(r'T(\d{1}):'), (match) => 'T0${match[1]}'));
}

@JsonSerializable()
class Call {
  static const MethodChannel _channel = MethodChannel('infobip_webrtc_sdk_flutter');
  static const MethodChannel _callEventChannel = MethodChannel('infobip_webrtc_sdk_flutter_call_event');

  final String id;
  final CallStatus status;
  bool muted;
  bool speakerphone;
  final int duration;
  @JsonKey(fromJson: customDateTimeFromString)
  final DateTime? startTime;
  final DateTime? establishTime;
  final DateTime? endTime;
  final User source;
  final User destination;

  @JsonKey(includeFromJson: false, includeToJson: false)
  CallEventListener? callEventListener;

  Call(
    this.id,
    this.status,
    this.muted,
    this.speakerphone,
    this.duration,
    this.startTime,
    this.establishTime,
    this.endTime,
    this.source,
    this.destination,
  ) {
    _callEventChannel.setMethodCallHandler(_onMethodCall);
  }

  Future<void> _onMethodCall(MethodCall call) async {
    if (call.method == "onEvent") {
      _onEvent(call);
    }
  }

  Future<void> _onEvent(MethodCall call) async {
    var map = call.arguments as Map<Object?, Object?>;
    var event = map["event"] as String;
    var data = map["data"] as String?;

    try {
      switch (event) {
        case "ringing":
          callEventListener?.onRinging();
          break;
        case "early-media":
          callEventListener?.onEarlyMedia();
          break;
        case "established":
          var callEstablishedEvent = CallEstablishedEvent.fromJson(jsonDecode(data!));
          callEventListener?.onEstablished(callEstablishedEvent);
          break;
        case "updated":
          var callUpdatedEvent = CallUpdatedEvent.fromJson(jsonDecode(data!));
          callEventListener?.onUpdated(callUpdatedEvent);
          break;
        case "hangup":
          callEventListener?.onHangup(CallHangupEvent.fromJson(jsonDecode(data!)));
          break;
        case "error":
          callEventListener?.onError(CallErrorEvent.fromJson(jsonDecode(data!)));
          break;
        default:
          throw Exception("Unknown call event! $event");
      }
    } catch (ex) {
      developer.log("Failed to emit call event!", error: ex);
      rethrow;
    }
  }

  factory Call.fromJson(Map<String, dynamic> json) => _$CallFromJson(json);

  Map<String, dynamic> toJson() => _$CallToJson(this);

  /// Mute the current user based on [mute].
  Future<void> mute(bool mute) async {
    await _channel.invokeMethod('mute', {"mute": mute});
    muted = mute;
  }

  /// Set whether speakerphone is [enabled].
  Future<void> setSpeakerphone(bool enabled) async {
    await _channel.invokeMethod('speakerphone', {"enabled": enabled});
    speakerphone = enabled;
  }

  /// Set whether the local user has their video enabled based on [localVideo].
  Future<void> localVideo(bool localVideo) async {
    await _channel.invokeMethod('localVideo', {"localVideo": localVideo});
  }

  /// Hangup the current call.
  Future<void> hangup() async {
    return _channel.invokeMethod('hangup', {});
  }

  /// Sets [orientation] as the new current camera orientation.
  Future<void> setCameraOrientation(CameraOrientation orientation) async {
    await _channel.invokeMethod("setCameraOrientation", {"orientation": orientation.name.toUpperCase()});
  }
}

@JsonSerializable()
class OutgoingCall extends Call {
  OutgoingCall(
    super.id,
    super.status,
    super.muted,
    super.speakerphone,
    super.duration,
    super.startTime,
    super.establishTime,
    super.endTime,
    super.source,
    super.destination,
  );

  factory OutgoingCall.fromJson(Map<String, dynamic> json) => _$OutgoingCallFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OutgoingCallToJson(this);
}

@JsonSerializable()
class IncomingCall extends Call {
  IncomingCall(
    super.id,
    super.status,
    super.muted,
    super.speakerphone,
    super.duration,
    super.startTime,
    super.establishTime,
    super.endTime,
    super.source,
    super.destination,
  );

  factory IncomingCall.fromJson(Map<String, dynamic> json) => _$IncomingCallFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$IncomingCallToJson(this);

  /// Accept the incoming call.
  Future<IncomingCall> accept(CallEventListener listener) async {
    callEventListener = listener;
    Call._channel.invokeMethod('accept', {});
    return this;
  }

  /// Reject the incoming call.
  Future<void> reject() async {
    return Call._channel.invokeMethod('decline', {});
  }
}
