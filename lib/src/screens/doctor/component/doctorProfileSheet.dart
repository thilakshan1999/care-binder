import 'package:care_sync/src/component/text/bodyText.dart';
import 'package:care_sync/src/component/text/sectionTittleText.dart';
import 'package:care_sync/src/component/text/subText.dart';
import 'package:care_sync/src/models/doctor.dart';
import 'package:flutter/material.dart';

class DoctorProfileSheet extends StatelessWidget {
  final Doctor doctor;

  const DoctorProfileSheet({
    super.key,
    required this.doctor,
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
                  SectionTittleText(text: doctor.name),
                  SubText(
                    text:
                        doctor.specialization ?? "Specialization not available",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            buildInfoRow(
              Icons.phone,
              doctor.phoneNumber,
              Theme.of(context).colorScheme.onSecondary,
            ),
            buildInfoRow(
              Icons.email,
              doctor.email,
              Theme.of(context).colorScheme.onSecondary,
            ),
            buildInfoRow(
              Icons.location_on,
              doctor.address,
              Theme.of(context).colorScheme.onSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String? value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(width: 20),
          value != null
              ? BodyText(
                  text: value,
                  textAlign: TextAlign.right,
                )
              : const SubText(
                  text: "Not available",
                  textAlign: TextAlign.right,
                )
        ],
      ),
    );
  }
}
