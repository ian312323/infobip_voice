import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'options.g.dart';

@JsonSerializable()
class VideoOptions {
  final CameraOrientation? cameraOrientation;

  const VideoOptions({this.cameraOrientation});

  factory VideoOptions.fromJson(Map<String, dynamic> json) => _$VideoOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$VideoOptionsToJson(this);
}

@JsonSerializable()
class RecordingOptions {
  final bool? audio;
  final bool? video;

  const RecordingOptions({this.audio, this.video});

  factory RecordingOptions.fromJson(Map<String, dynamic> json) => _$RecordingOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$RecordingOptionsToJson(this);
}

@JsonSerializable()
class CallOptions {
  final bool? video;
  final RecordingOptions? recordingOptions;
  final VideoOptions? videoOptions;
  final Map<String, String>? customData;

  const CallOptions({this.video, this.recordingOptions, this.videoOptions, this.customData});

  factory CallOptions.fromJson(Map<String, dynamic> json) => _$CallOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$CallOptionsToJson(this);
}
