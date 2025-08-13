import 'package:care_sync/src/models/appointment.dart';
import 'package:care_sync/src/utils/textFormatUtils.dart';
import 'package:flutter/material.dart';

import '../../../component/text/bodyText.dart';
import '../../../component/text/sectionTittleText.dart';
import '../../../component/text/subText.dart';

class AppointmentDetailSheet extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailSheet({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  SectionTittleText(text: appointment.name),
                  const SizedBox(
                    height: 3,
                  ),
                  SubText(
                    text: TextFormatUtils.formatEnum(appointment.type),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            buildInfoRow('Appointment Date',
                TextFormatUtils.formatDate(appointment.appointmentDateTime)),
            buildInfoRow('Doctor',
                appointment.doctor != null ? appointment.doctor!.name : "-"),
          ],
        ),
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
