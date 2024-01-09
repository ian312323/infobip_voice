import 'package:json_annotation/json_annotation.dart';

part 'events.g.dart';

@JsonSerializable()
class CallHangupEvent {
  final int id;
  final String? name;
  final String? description;

  const CallHangupEvent(this.id, this.name, this.description);

  factory CallHangupEvent.fromJson(Map<String, dynamic> json) => _$CallHangupEventFromJson(json);

  Map<String, dynamic> toJson() => _$CallHangupEventToJson(this);
}

@JsonSerializable()
class CallEstablishedEvent {
  final bool hasLocalVideo;
  final bool hasRemoteVideo;

  const CallEstablishedEvent(this.hasLocalVideo, this.hasRemoteVideo);

  factory CallEstablishedEvent.fromJson(Map<String, dynamic> json) => _$CallEstablishedEventFromJson(json);

  Map<String, dynamic> toJson() => _$CallEstablishedEventToJson(this);
}

@JsonSerializable()
class CallUpdatedEvent {
  final bool hasLocalVideo;
  final bool hasRemoteVideo;

  const CallUpdatedEvent(this.hasLocalVideo, this.hasRemoteVideo);

  factory CallUpdatedEvent.fromJson(Map<String, dynamic> json) => _$CallUpdatedEventFromJson(json);

  Map<String, dynamic> toJson() => _$CallUpdatedEventToJson(this);
}

@JsonSerializable()
class CallErrorEvent {
  final int id;
  final String? name;
  final String? description;

  const CallErrorEvent(this.id, this.name, this.description);

  factory CallErrorEvent.fromJson(Map<String, dynamic> json) => _$CallErrorEventFromJson(json);

  Map<String, dynamic> toJson() => _$CallErrorEventToJson(this);
}
