import 'package:flutter/material.dart';

class QuestionText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  const QuestionText({
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
        height: 1.3,
        letterSpacing: 0.6,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
