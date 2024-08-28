# Infobip Voice Flutter Plugin (infobip_voice)

[![Pub](https://img.shields.io/pub/v/infobip_voice.svg)](https://pub.dev/packages/infobip_voice)

## Introduction

Infobip Voice Flutter Plugin (infobip_voice) is a Unoffical Flutter plugin that allows you to integrate Infobip's real-time communication features into your Flutter applications seamlessly. This plugin serves as a wrapper for both iOS ([infobio-rtc-ios](https://github.com/infobip/infobip-rtc-ios)) and Android ([infobip-rtc-android](https://github.com/infobip/infobip-rtc-android)) SDKs provided by Infobip, providing you with a unified interface for real-time communications.


## Getting Started

To get started with Infobip Voice Flutter Plugin, follow these simple steps:

1. **Installation:** Add the `infobip_voice` package to your `pubspec.yaml` file and run `flutter pub get`.

    ```yaml
    dependencies:
      infobip_voice: latest
    ```

2. **Import:** Import the package in your Dart code.

    ```dart
    import 'package:infobip_voice/infobip_voice.dart';
    ```

3. **Usage:** Integrate Infobip Voice into your application and start utilizing real-time communication features.
    ```dart
    // Initialize and register the client
    await InfobipRTC.registerClient(
      apiKey: 'YOUR_API_KEY',
      identity: 'USER_IDENTITY',
      applicationId: 'YOUR_APPLICATION_ID',
      displayName: 'USER_DISPLAY_NAME',
      pushConfigId: 'YOUR_PUSH_CONFIG_ID', // Optional, for iOS push notifications
    );

    // Check if the client is logged in
    bool isLoggedIn = InfobipRTC.instance.isLoggedIn;

    // Get the token if logged in
    String? token = InfobipRTC.instance.token;

    // Unregister the client when done
    await InfobipRTC.instance.unregisterClient();
    ```

## Features Checklist
#### Note: Features that are crossed out will not be implemented any time soon, open to contributions

- [x] **Authentication**
- [x] **Phone Call**
- [x] **WebRTC Call**
- [x] **Incoming Call**
- [ ] **~~SIP Trunk~~**
- [ ] **~~Video Call~~**
- [ ] **~~Conversations~~**
- [x] **Push Notification [Only iOS, Android uses active connection]**

## Updates and Versioning

This Unoffical Flutter plugin serves as a continuation of the discontinued official `infobip_rtc` plugin. The update ensures compatibility with the latest Infobip SDKs.

Please do not report any bugs related to this plugin directly to Infobip, as this plugin does not have any offical affliation with Infobip. If you encounter any issues, feel free to [file a bug on GitHub](https://github.com/icodelifee/infobip_voice/issues).