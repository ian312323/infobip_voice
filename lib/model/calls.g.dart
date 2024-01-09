// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calls.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      displayIdentifier: json['displayIdentifier'] as String?,
      identifier: json['identifier'] as String,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'displayIdentifier': instance.displayIdentifier,
      'identifier': instance.identifier,
      'type': instance.type,
    };

Call _$CallFromJson(Map<String, dynamic> json) => Call(
      json['id'] as String,
      $enumDecode(_$CallStatusEnumMap, json['status']),
      json['muted'] as bool,
      json['speakerphone'] as bool,
      json['duration'] as int,
      customDateTimeFromString(json['startTime'] as String),
      json['establishTime'] == null
          ? null
          : DateTime.parse(json['establishTime'] as String),
      json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      User.fromJson(json['source'] as Map<String, dynamic>),
      User.fromJson(json['destination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CallToJson(Call instance) => <String, dynamic>{
      'id': instance.id,
      'status': _$CallStatusEnumMap[instance.status]!,
      'muted': instance.muted,
      'speakerphone': instance.speakerphone,
      'duration': instance.duration,
      'startTime': instance.startTime?.toIso8601String(),
      'establishTime': instance.establishTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'source': instance.source,
      'destination': instance.destination,
    };

const _$CallStatusEnumMap = {
  CallStatus.initializing: 'INITIALIZING',
  CallStatus.calling: 'CALLING',
  CallStatus.ringing: 'RINGING',
  CallStatus.connecting: 'CONNECTING',
  CallStatus.established: 'ESTABLISHED',
  CallStatus.finishing: 'FINISHING',
  CallStatus.finished: 'FINISHED',
};

OutgoingCall _$OutgoingCallFromJson(Map<String, dynamic> json) => OutgoingCall(
      json['id'] as String,
      $enumDecode(_$CallStatusEnumMap, json['status']),
      json['muted'] as bool,
      json['speakerphone'] as bool,
      json['duration'] as int,
      customDateTimeFromString(json['startTime'] as String),
      json['establishTime'] == null
          ? null
          : DateTime.parse(json['establishTime'] as String),
      json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      User.fromJson(json['source'] as Map<String, dynamic>),
      User.fromJson(json['destination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OutgoingCallToJson(OutgoingCall instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$CallStatusEnumMap[instance.status]!,
      'muted': instance.muted,
      'speakerphone': instance.speakerphone,
      'duration': instance.duration,
      'startTime': instance.startTime?.toIso8601String(),
      'establishTime': instance.establishTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'source': instance.source,
      'destination': instance.destination,
    };
