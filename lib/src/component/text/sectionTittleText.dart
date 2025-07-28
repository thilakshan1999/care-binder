import 'package:flutter/material.dart';

class SectionTittleText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  const SectionTittleText({
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
        letterSpacing: 0.6,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
