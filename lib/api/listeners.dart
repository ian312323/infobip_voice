import 'package:infobip_voice/model/events.dart';

abstract class CallEventListener {
  void onEarlyMedia();
  void onEstablished(CallEstablishedEvent callEstablishedEvent);
  void onHangup(CallHangupEvent callHangupEvent);
  void onError(CallErrorEvent callErrorEvent);
  void onRinging();
  void onUpdated(CallUpdatedEvent callUpdatedEvent);
}
