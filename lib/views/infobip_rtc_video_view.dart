import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class InfobipRTCVideoView extends StatefulWidget {
  final String streamId;

  const InfobipRTCVideoView(this.streamId, {super.key});

  @override
  State<InfobipRTCVideoView> createState() => _InfobipRTCVideoViewState();
}

class _InfobipRTCVideoViewState extends State<InfobipRTCVideoView>
    with TickerProviderStateMixin {
  static const String viewType = '<infobip-rtc-video-view>';

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

  Widget _buildIOSWidget() {
    return UiKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: {"streamId": widget.streamId},
      creationParamsCodec: const StandardMessageCodec(),
    );
  }

  Widget _buildAndroidWidget() {
    Map<String, dynamic> creationParams = <String, dynamic>{
      "streamId": widget.streamId
    };

    return PlatformViewLink(
      viewType: viewType,
      surfaceFactory:
          (BuildContext context, PlatformViewController controller) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (PlatformViewCreationParams params) {
        return PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onFocus: () {
            params.onFocusChanged(true);
          },
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..create();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return _buildAndroidWidget();
    } else if (Platform.isIOS) {
      return _buildIOSWidget();
    } else {
      throw Exception("No video view supported for the current platform!");
    }
  }
}
