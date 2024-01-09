// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoOptions _$VideoOptionsFromJson(Map<String, dynamic> json) => VideoOptions(
      cameraOrientation: $enumDecodeNullable(
          _$CameraOrientationEnumMap, json['cameraOrientation']),
    );

Map<String, dynamic> _$VideoOptionsToJson(VideoOptions instance) =>
    <String, dynamic>{
      'cameraOrientation':
          _$CameraOrientationEnumMap[instance.cameraOrientation],
    };

const _$CameraOrientationEnumMap = {
  CameraOrientation.front: 'FRONT',
  CameraOrientation.back: 'BACK',
};

RecordingOptions _$RecordingOptionsFromJson(Map<String, dynamic> json) =>
    RecordingOptions(
      audio: json['audio'] as bool?,
      video: json['video'] as bool?,
    );

Map<String, dynamic> _$RecordingOptionsToJson(RecordingOptions instance) =>
    <String, dynamic>{
      'audio': instance.audio,
      'video': instance.video,
    };

CallOptions _$CallOptionsFromJson(Map<String, dynamic> json) => CallOptions(
      video: json['video'] as bool?,
      recordingOptions: json['recordingOptions'] == null
          ? null
          : RecordingOptions.fromJson(
              json['recordingOptions'] as Map<String, dynamic>),
      videoOptions: json['videoOptions'] == null
          ? null
          : VideoOptions.fromJson(json['videoOptions'] as Map<String, dynamic>),
      customData: (json['customData'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$CallOptionsToJson(CallOptions instance) =>
    <String, dynamic>{
      'video': instance.video,
      'recordingOptions': instance.recordingOptions,
      'videoOptions': instance.videoOptions,
      'customData': instance.customData,
    };
