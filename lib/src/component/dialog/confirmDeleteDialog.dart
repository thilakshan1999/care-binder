import 'package:care_sync/src/component/text/bodyText.dart';
import 'package:care_sync/src/component/text/btnText.dart';
import 'package:care_sync/src/component/text/sectionTittleText.dart';
import 'package:flutter/material.dart';

import '../../theme/customColors.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final String btnLabel;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.btnLabel,
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
            Navigator.of(context).pop();
            onConfirm();
          },
          child: BtnText(
              text: btnLabel, color: Theme.of(context).colorScheme.onPrimary),
        ),
      ],
    );
  }
}

Future<void> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onConfirm,
  String btnLabel = "Delete",
}) {
  return showDialog(
    context: context,
    builder: (_) => ConfirmDialog(
      title: title,
      message: message,
      onConfirm: onConfirm,
      btnLabel: btnLabel,
    ),
  );
}
