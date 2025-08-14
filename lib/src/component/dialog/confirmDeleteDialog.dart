import 'package:care_sync/src/component/text/bodyText.dart';
import 'package:care_sync/src/component/text/btnText.dart';
import 'package:care_sync/src/component/text/sectionTittleText.dart';
import 'package:flutter/material.dart';

import '../../theme/customColors.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;

  const ConfirmDeleteDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: SectionTittleText(
        text: title,
        textAlign: TextAlign.center,
      ),
      content: BodyText(text: message),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Theme.of(context).extension<CustomColors>()?.success,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: BtnText(
              text: "Cancel", color: Theme.of(context).colorScheme.onPrimary),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
          child: BtnText(
              text: "Delete", color: Theme.of(context).colorScheme.onPrimary),
        ),
      ],
    );
  }
}

Future<void> showConfirmDeleteDialog({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onConfirm,
}) {
  return showDialog(
    context: context,
    builder: (_) => ConfirmDeleteDialog(
      title: title,
      message: message,
      onConfirm: onConfirm,
    ),
  );
}
