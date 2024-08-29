import 'package:flutter/material.dart';
import 'package:infobip_voice/infobip_rtc.dart';
import 'package:infobip_voice/model/enums.dart';
import 'package:infobip_voice/model/options.dart';
import 'package:infobip_voice_showcase/core/model.dart';
import 'package:infobip_voice_showcase/ui/pages/active_call/active_call_page.dart';
import 'package:infobip_voice_showcase/ui/pages/active_call/incoming_call_page.dart';
import 'package:permission_handler/permission_handler.dart';

class WebRtcTab extends StatefulWidget {
  const WebRtcTab({Key? key}) : super(key: key);

  @override
  State<WebRtcTab> createState() => _WebRtcTabState();
}

class _WebRtcTabState extends State<WebRtcTab> with TickerProviderStateMixin {
  final TextEditingController _callTargetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _callTargetController,
              ),
              ElevatedButton(onPressed: onCallClick, child: const Text("Call"))
            ],
          ),
        )
      ],
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    InfobipRTC.handleIncomingCalls((call) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IncomingCallPage(
            incomingCall: call,
          ),
        ),
      );
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    initPlatformState();
  }

  Future<void> onCallClick() async {
    if (!(await Permission.microphone.request().isGranted)) {
      return Future.error("No microphone permission!");
    }
    if (!(await Permission.camera.request().isGranted)) {
      return Future.error("No camera permission!");
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActiveCallPage(
          CallType.webrtc,
          _callTargetController.value.text,
          const CallOptions(
            video: true,
            recordingOptions: RecordingOptions(
              audio: true,
              video: true,
            ),
            videoOptions: VideoOptions(
              cameraOrientation: CameraOrientation.front,
            ),
          ),
        ),
      ),
    );
  }
}
