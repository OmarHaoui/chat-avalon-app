import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

class defaultButtton extends StatelessWidget {
  defaultButtton({
    required this.onPressed,
    required this.childText,
    required this.halfWidth,
    required this.halfHeight,
    this.transparent = false,
  });
  dynamic Function() onPressed;
  bool transparent;
  String childText;
  double halfWidth;
  double halfHeight;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            transparent ? Colors.transparent : TColors.primary),
        foregroundColor: MaterialStateProperty.all<Color>(
            transparent ? TColors.primary : TColors.textWhite),
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: "Poppins",
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: halfWidth, vertical: halfHeight),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(childText),
    );
  }
}
