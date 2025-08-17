import 'package:care_sync/src/models/vital.dart';
import 'package:care_sync/src/utils/textFormatUtils.dart';
import 'package:flutter/material.dart';
import '../../../component/text/bodyText.dart';
import '../../../component/text/sectionTittleText.dart';

class VitalDetailSheet extends StatelessWidget {
  final Vital vital;

  const VitalDetailSheet({
    super.key,
    required this.vital,
  });

  @override
  Widget build(BuildContext context) {
    final lastMeasurement =
        vital.measurements.isNotEmpty ? vital.measurements.last : null;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                SectionTittleText(text: vital.name),
              ],
            ),
          ),
          const SizedBox(height: 20),
          buildInfoRow('Start Date',
              TextFormatUtils.formatDateTime(vital.startDateTime)),
          buildInfoRow(
              'Duration', TextFormatUtils.formatDuration(vital.remindDuration)),
          buildInfoRow('Unit', vital.unit ?? '-'),
          buildInfoRow(
            'Last Measure At',
            TextFormatUtils.formatDateTime(lastMeasurement?.dateTime),
          ),
          buildInfoRow(
            'Last Value',
            lastMeasurement?.value ?? '-',
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BodyText(text: label),
          Flexible(child: BodyText(text: value)),
        ],
      ),
    );
  }
}
