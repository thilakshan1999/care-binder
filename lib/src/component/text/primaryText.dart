import 'package:flutter/material.dart';

class PrimaryText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  const PrimaryText({
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
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
