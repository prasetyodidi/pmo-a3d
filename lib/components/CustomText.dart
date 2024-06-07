import 'package:a3d/constants/index.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final TextAlign? textAlign;

  const CustomText({
    Key? key,
    required this.text,
    this.textStyle,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textStyle ?? TextStyle(
        fontSize: BASE_FONTSIZE
      ), // Use custom textStyle if provided, else use default
      textAlign: textAlign ?? TextAlign.start, // Use custom textAlign if provided, else use default
    );
  }
}
