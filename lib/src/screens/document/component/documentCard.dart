import 'package:care_sync/src/component/badge/simpleBadge.dart';
import 'package:care_sync/src/component/text/bodyText.dart';
import 'package:care_sync/src/component/text/primaryText.dart';
import 'package:care_sync/src/component/text/subText.dart';
import 'package:care_sync/src/models/enums/documentType.dart';
import 'package:care_sync/src/utils/textFormatUtils.dart';
import 'package:flutter/material.dart';

import 'package:accordion/accordion.dart';

import '../../../theme/customColors.dart';
import '../documentInfoScreen.dart';

AccordionSection documentCard({
  required BuildContext context,
  required int id,
  required String name,
  required DateTime updatedTime,
  required String summary,
  required DocumentType type,
}) {
  Color getDocumentTypeColor(DocumentType type) {
    switch (type) {
      case DocumentType.PRESCRIPTION:
        return Colors.blue;
      case DocumentType.MEDICAL_REPORT:
        return Colors.green;
      case DocumentType.LAB_REPORT:
        return Colors.orange;
      case DocumentType.DISCHARGE_SUMMARY:
        return Colors.purple;
      case DocumentType.REFERRAL_LETTER:
        return Colors.teal;
      case DocumentType.TEST_RESULT:
        return Colors.red;
      case DocumentType.OTHER:
      default:
        return Colors.grey;
    }
  }

  void navigateToDocumentInfo(
    BuildContext context,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DocumentInfoScreen(
          id: id,
          name: name,
        ),
      ),
    );
  }

  return AccordionSection(
    isOpen: false,
    leftIcon: InkWell(
      onTap: () {
        navigateToDocumentInfo(context);
      },
      child: Icon(
        Icons.description,
        size: 32,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
    header: InkWell(
      onTap: () {
        navigateToDocumentInfo(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(text: name),
          const SizedBox(height: 6),
          SubText(
            text: "Upload At ${TextFormatUtils.formatDateTime(updatedTime)}",
          ),
          const SizedBox(height: 6),
          SimpleBadge(
            color: getDocumentTypeColor(type),
            child: Text(
              TextFormatUtils.formatEnumName(type.name),
              style: TextStyle(
                color: getDocumentTypeColor(type),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    ),
    content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: BodyText(text: summary),
    ),
    rightIcon: const Icon(Icons.expand_more, size: 24),
    headerPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    contentBackgroundColor:
        Theme.of(context).extension<CustomColors>()?.primarySurface,
    contentHorizontalPadding: 16,
    contentBorderColor: Colors.blue.shade50,
    contentBorderWidth: 1,
  );
}
