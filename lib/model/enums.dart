import 'package:json_annotation/json_annotation.dart';

enum CameraOrientation {
  @JsonValue("FRONT")
  front,
  @JsonValue("BACK")
  back
}

enum CallStatus {
  @JsonValue("INITIALIZED")
  initialized,
  @JsonValue("INITIALIZING")
  initializing,
  @JsonValue("CALLING")
  calling,
  @JsonValue("RINGING")
  ringing,
  @JsonValue("CONNECTING")
  connecting,
  @JsonValue("ESTABLISHED")
  established,
  @JsonValue("FINISHING")
  finishing,
  @JsonValue("FINISHED")
  finished
}

T caseInsensitiveEnum<T extends Enum>(List<T> enumValues, String value) {
  for (var enumValue in enumValues) {
    if (enumValue.name.toLowerCase() == value.toLowerCase()) {
      return enumValue;
    }
  }

  throw Exception("Unknown enum value $value");
}
