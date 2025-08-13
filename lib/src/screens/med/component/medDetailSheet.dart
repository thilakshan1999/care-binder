import 'package:care_sync/src/component/text/bodyText.dart';
import 'package:care_sync/src/component/text/primaryText.dart';
import 'package:care_sync/src/component/text/sectionTittleText.dart';
import 'package:care_sync/src/component/text/subText.dart';
import 'package:care_sync/src/models/med.dart';
import 'package:flutter/material.dart';

import '../../../utils/textFormatUtils.dart';

class MedDetailSheet extends StatelessWidget {
  final Med med;

  const MedDetailSheet({
    super.key,
    required this.med,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildInfoRow(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: BodyText(text: label),
            ),
            Flexible(child: BodyText(text: value)),
          ],
        ),
      );
    }

    Widget buildGroupCard(String title, List<Widget> children) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText(text: title),
              const SizedBox(height: 12),
              ...children,
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                SectionTittleText(text: med.name),
                const SizedBox(
                  height: 3,
                ),
                SubText(text: TextFormatUtils.formatEnum(med.medForm)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          buildGroupCard('Medication Info', [
            buildInfoRow('Health Condition', med.healthCondition ?? '-'),
            buildInfoRow('Dosage', med.dosage ?? '-'),
            buildInfoRow(
                'Instruction', TextFormatUtils.formatEnum(med.instruction)),
          ]),
          buildGroupCard('Dates', [
            buildInfoRow(
                'Start Date', TextFormatUtils.formatDate(med.startDate)),
            buildInfoRow('End Date', TextFormatUtils.formatDate(med.endDate)),
            buildInfoRow('Intake Interval',
                TextFormatUtils.formatDuration(med.intakeInterval)),
          ]),
          buildGroupCard('Inventory', [
            buildInfoRow('Stock', med.stock?.toString() ?? '-'),
            buildInfoRow(
                'Reminder Limit', med.reminderLimit?.toString() ?? '-'),
          ]),
        ],
      ),
    );
  }
}
