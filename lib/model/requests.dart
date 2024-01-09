import 'package:infobip_voice/api/listeners.dart';

class CallRequest {
  const CallRequest({
    required this.token,
    required this.destination,
    required this.callEventListener,
  });

  final String token;
  final String destination;
  final CallEventListener callEventListener;
}

class CallConversationsRequest {
  const CallConversationsRequest({
    required this.token,
    required this.callEventListener,
  });

  final String token;
  final CallEventListener callEventListener;
}
