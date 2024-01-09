// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallHangupEvent _$CallHangupEventFromJson(Map<String, dynamic> json) =>
    CallHangupEvent(
      json['id'] as int,
      json['name'] as String?,
      json['description'] as String?,
    );

Map<String, dynamic> _$CallHangupEventToJson(CallHangupEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };

CallEstablishedEvent _$CallEstablishedEventFromJson(
        Map<String, dynamic> json) =>
    CallEstablishedEvent(
      json['hasLocalVideo'] as bool,
      json['hasRemoteVideo'] as bool,
    );

Map<String, dynamic> _$CallEstablishedEventToJson(
        CallEstablishedEvent instance) =>
    <String, dynamic>{
      'hasLocalVideo': instance.hasLocalVideo,
      'hasRemoteVideo': instance.hasRemoteVideo,
    };

CallUpdatedEvent _$CallUpdatedEventFromJson(Map<String, dynamic> json) =>
    CallUpdatedEvent(
      json['hasLocalVideo'] as bool,
      json['hasRemoteVideo'] as bool,
    );

Map<String, dynamic> _$CallUpdatedEventToJson(CallUpdatedEvent instance) =>
    <String, dynamic>{
      'hasLocalVideo': instance.hasLocalVideo,
      'hasRemoteVideo': instance.hasRemoteVideo,
    };

CallErrorEvent _$CallErrorEventFromJson(Map<String, dynamic> json) =>
    CallErrorEvent(
      json['id'] as int,
      json['name'] as String?,
      json['description'] as String?,
    );

Map<String, dynamic> _$CallErrorEventToJson(CallErrorEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };
