// import 'package:flutter/material.dart';
// import 'package:infobip_rtc/model/enums.dart';
// import 'package:infobip_rtc/model/options.dart';
// import 'package:infobip_rtc_showcase/core/model.dart';
// import 'package:infobip_rtc_showcase/ui/pages/active_call/active_call_page.dart';
// import 'package:permission_handler/permission_handler.dart';

// class ConversationsTab extends StatefulWidget {
//   const ConversationsTab({Key? key}) : super(key: key);

//   @override
//   State<ConversationsTab> createState() => _ConversationsTabState();
// }

// class _ConversationsTabState extends State<ConversationsTab>
//     with TickerProviderStateMixin {
//   @override
//   void initState() {
//     super.initState();

//     initPlatformState();
//   }

//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;

//     setState(() {});
//   }

//   Future<void> onCallClick() async {
//     if (!(await Permission.microphone.request().isGranted)) {
//       return Future.error("No microphone permission!");
//     }
//     if (!(await Permission.camera.request().isGranted)) {
//       return Future.error("No camera permission!");
//     }

//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => const ActiveCallPage(
//                 CallType.conversations,
//                 null,
//                 CallOptions(
//                     video: true,
//                     recordingOptions:
//                         RecordingOptions(audio: true, video: true),
//                     videoOptions: VideoOptions(
//                         cameraOrientation: CameraOrientation.front)))));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ElevatedButton(onPressed: onCallClick, child: const Text("Call"))
//       ],
//     );
//   }
// }
