import 'package:flutter/material.dart';

class MaxWidthConstrainedBox extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const MaxWidthConstrainedBox({
    super.key,
    required this.child,
    this.maxWidth = 600,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    );
  }
}
