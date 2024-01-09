import 'package:flutter/material.dart';
import 'package:infobip_voice_showcase/core/model.dart';
import 'package:infobip_voice_showcase/ui/pages/active_call/active_call_page.dart';
import 'package:permission_handler/permission_handler.dart';

class PhoneCallTab extends StatefulWidget {
  const PhoneCallTab({Key? key}) : super(key: key);

  @override
  State<PhoneCallTab> createState() => _PhoneCallTabState();
}

class _PhoneCallTabState extends State<PhoneCallTab> with TickerProviderStateMixin {
  final TextEditingController _callTargetController = TextEditingController();

  @override
  void initState() {
    super.initState();

    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {});
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
          CallType.phone,
          _callTargetController.value.text,
          null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _callTargetController,
        ),
        ElevatedButton(onPressed: onCallClick, child: const Text("Call"))
      ],
    );
  }
}
