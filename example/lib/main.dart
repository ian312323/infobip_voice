import 'package:flutter/material.dart';

import 'ui/pages/login_page/login_page.dart';

void main() {
  runApp(MaterialApp(
    title: 'InfoBip WebRTC',
    theme: ThemeData(
      brightness: Brightness.light,
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
    ),
    themeMode: ThemeMode.dark,
    home: const LoginPage(),
  ));
}
