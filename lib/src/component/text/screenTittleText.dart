import 'package:flutter/material.dart';

class ScreenTittleText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  const ScreenTittleText({
    super.key,
    required this.text,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        height: 1,
        letterSpacing: 1,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
