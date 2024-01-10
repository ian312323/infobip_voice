import 'package:infobip_voice/api/listeners.dart';

class CallRequest {
  const CallRequest({
    required this.destination,
    required this.callEventListener,
  });

  final String destination;
  final CallEventListener callEventListener;
}

class CallConversationsRequest {
  const CallConversationsRequest({
    required this.callEventListener,
  });

  final CallEventListener callEventListener;
}
