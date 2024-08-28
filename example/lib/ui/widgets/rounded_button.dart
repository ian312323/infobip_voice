import 'package:flutter/material.dart';

import '../size_config.dart';

class RoundedButton extends StatelessWidget {
  final double size;
  final Icon icon;
  final Color color, iconColor;
  final VoidCallback press;

  const RoundedButton({
    Key? key,
    this.size = 64,
    required this.icon,
    this.color = Colors.white,
    this.iconColor = Colors.black,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenWidth(size),
      width: getProportionateScreenWidth(size),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: color,
            padding: EdgeInsets.all(15 / 64 * size),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100)),
            )),
        onPressed: press,
        child: FittedBox(child: icon),
      ),
    );
  }
}
