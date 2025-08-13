import 'package:care_sync/src/component/text/sectionTittleText.dart';
import 'package:flutter/material.dart';

class DocumentSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onIconPressed;

  const DocumentSectionHeader({
    super.key,
    required this.title,
    required this.onIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: SectionTittleText(
          text: title,
          textAlign: TextAlign.left,
        )),
        IconButton(
          icon: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
          onPressed: onIconPressed,
        ),
      ],
    );
  }
}
