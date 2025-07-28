import 'package:flutter/material.dart';

class BtnText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final Color color;

  const BtnText({
    super.key,
    required this.text,
    required this.color,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          height: 1,
          letterSpacing: 0.6,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: color),
    );
  }
}
