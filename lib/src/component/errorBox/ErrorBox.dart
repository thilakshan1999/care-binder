import 'package:care_sync/src/component/text/btnText.dart';
import 'package:care_sync/src/component/text/primaryText.dart';
import 'package:care_sync/src/component/text/sectionTittleText.dart';
import 'package:care_sync/src/component/text/subText.dart';
import 'package:care_sync/src/theme/customColors.dart';
import 'package:flutter/material.dart';

class ErrorBox extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const ErrorBox({
    super.key,
    this.title = 'Oops! Something went wrong',
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: screenWidth,
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).extension<CustomColors>()?.primarySurface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            PrimaryText(text: title),
            const SizedBox(height: 12),
            SubText(text: message),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: BtnText(
                    text: "Retry",
                    color: Theme.of(context).colorScheme.onPrimary),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
