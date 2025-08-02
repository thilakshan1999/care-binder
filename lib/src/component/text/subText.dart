import 'package:flutter/material.dart';

class SubText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  const SubText({
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
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }
}
