import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CallsTab extends StatefulWidget {
  const CallsTab({Key? key}) : super(key: key);

  @override
  State<CallsTab> createState() => _CallsTabState();
}

class _CallsTabState extends State<CallsTab> with TickerProviderStateMixin {
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
      return Future.error("No permission!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(onPressed: onCallClick, child: const Text("Call"))
      ],
    );
  }
}
