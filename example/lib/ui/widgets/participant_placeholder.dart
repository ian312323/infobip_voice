import 'package:flutter/material.dart';

class ParticipantPlaceholder extends StatelessWidget {
  const ParticipantPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Image.asset("images/avatar.png")],
    );
  }
}
