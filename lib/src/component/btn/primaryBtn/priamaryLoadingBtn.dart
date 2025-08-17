import 'package:care_sync/src/component/text/btnText.dart';
import 'package:flutter/material.dart';

class PrimaryLoadingBtn extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool fullWidth;
  final bool loading;
  final Color? backgroundColor;

  const PrimaryLoadingBtn({
    super.key,
    required this.loading,
    required this.label,
    required this.onPressed,
    this.fullWidth = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
          onPressed: loading ? () => {} : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                backgroundColor ?? Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          ),
          child: loading
              ? SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.surface),
                    strokeWidth: 2,
                  ),
                )
              : BtnText(
                  text: label,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                )),
    );
  }
}
