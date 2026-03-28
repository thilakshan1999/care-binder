import 'package:care_sync/src/utils/textFormatUtils.dart';
import 'package:flutter/material.dart';

class PrimaryText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final bool singleLine;

  const PrimaryText({
    super.key,
    required this.text,
    this.textAlign = TextAlign.left,
    this.singleLine = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      TextFormatUtils.formatName(text),
      textAlign: textAlign,
      maxLines: singleLine ? 1 : null,
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
