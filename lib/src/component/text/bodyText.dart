import 'package:flutter/material.dart';

class BodyText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  const BodyText({
    super.key,
    required this.text,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        height: 1,
        letterSpacing: 0.5,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
