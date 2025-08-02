import 'package:care_sync/src/component/text/btnText.dart';
import 'package:flutter/material.dart';

class PrimaryBtn extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool fullWidth;

  const PrimaryBtn({
    super.key,
    required this.label,
    required this.onPressed,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          ),
          child: BtnText(
            text: label,
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          )),
    );
  }
}
