import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infobip_voice/api/listeners.dart';
import 'package:infobip_voice/infobip_rtc.dart';
import 'package:infobip_voice/model/calls.dart';
import 'package:infobip_voice/model/events.dart';
import 'package:infobip_voice/model/options.dart';
import 'package:infobip_voice/model/requests.dart';
import 'package:infobip_voice_showcase/core/model.dart';
import 'package:infobip_voice_showcase/ui/widgets/participant_placeholder.dart';
import 'package:infobip_voice_showcase/ui/widgets/rounded_button.dart';

import '../../size_config.dart';

class ActiveCallPage extends StatefulWidget {
  final CallType callType;

  final String? destination;
  final CallOptions? options;
  const ActiveCallPage(
    this.callType,
    this.destination,
    this.options, {
    Key? key,
  }) : super(key: key);

  @override
  State<ActiveCallPage> createState() => _ActiveCallPageState();
}

class _ActiveCallPageState extends State<ActiveCallPage> with TickerProviderStateMixin implements CallEventListener {
  bool muted = false;
  bool video = true;
  bool speaker = false;

  bool callEstablished = false;
  Call? currentCall;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [],
      ),
      body: GridView.builder(
        padding: EdgeInsets.zero,
        itemCount: 2, // todo
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.5,
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) => const ParticipantPlaceholder(),
      ),
      bottomNavigationBar: buildBottomNavBar(),
    );
  }

  Container buildBottomNavBar() {
    return Container(
      color: const Color(0xFF091C40),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              RoundedButton(
                color: const Color(0xFFFF0038),
                iconColor: Colors.white,
                size: 48,
                icon: const Icon(Icons.call_end),
                press: performHangup,
              ),
              const Spacer(flex: 3),
              RoundedButton(
                color: const Color(0xFF2C384D),
                iconColor: Colors.white,
                size: 48,
                icon: muted ? const Icon(Icons.mic_off) : const Icon(Icons.mic),
                press: toggleMute,
              ),
              const Spacer(),
              RoundedButton(
                color: const Color(0xFF2C384D),
                iconColor: Colors.white,
                size: 48,
                icon: speaker ? const Icon(Icons.speaker_phone) : const Icon(Icons.volume_up),
                press: toggleSpeaker,
              ),
              const Spacer(),
              RoundedButton(
                color: const Color(0xFF2C384D),
                iconColor: Colors.white,
                size: 48,
                icon: video ? const Icon(Icons.videocam) : const Icon(Icons.videocam_off),
                press: toggleVideo,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initiateCall() async {
    switch (widget.callType) {
      case CallType.webrtc:
        currentCall = await InfobipRTC.call(
          callRequest: CallRequest(
            destination: widget.destination!,
            callEventListener: this,
          ),
          options: widget.options,
        );
        break;
      case CallType.phone:
        currentCall = await InfobipRTC.callPhoneNumber(
          callRequest: CallRequest(
            destination: widget.destination!,
            callEventListener: this,
          ),
        );
        break;
      case CallType.incoming:
        currentCall = await (InfobipRTC.activeCall as IncomingCall).accept(this);
        break;
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {});

    initiateCall();
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void onEarlyMedia() {
    Fluttertoast.showToast(
        msg: "onEarlyMedia",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void onError(CallErrorEvent callErrorEvent) {
    Fluttertoast.showToast(
        msg: "onError",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void onEstablished(CallEstablishedEvent callEstablishedEvent) {
    Fluttertoast.showToast(
        msg: "onEstablished",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);

    setState(() {
      callEstablished = true;
    });
  }

  @override
  void onHangup(CallHangupEvent callHangupEvent) {
    Fluttertoast.showToast(
      msg: "onHangup",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    Navigator.pop(context);
  }

  @override
  void onRinging() {
    Fluttertoast.showToast(
        msg: "onRinging",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void onUpdated(CallUpdatedEvent callUpdatedEvent) {
    Fluttertoast.showToast(
        msg: "onUpdated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);

    setState(() {});
  }

  Future<void> performHangup() async {
    await currentCall?.hangup();
  }

  Future<void> toggleMute() async {
    setState(() {
      muted = !muted;
      currentCall?.mute(muted);
    });
  }

  Future<void> toggleSpeaker() async {
    setState(() {
      speaker = !speaker;
      currentCall?.setSpeakerphone(speaker);
    });
  }

  Future<void> toggleVideo() async {
    setState(() {
      video = !video;
      currentCall?.localVideo(video);
    });
  }
}
