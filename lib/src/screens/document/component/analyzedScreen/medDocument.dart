import 'package:care_sync/src/models/medWithStatus.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/ph.dart';

import '../../../../component/bottomSheet/bottomSheet.dart';
import '../../../../component/card/InfoCard.dart';
import '../../../../models/med.dart';
import '../../../../utils/textFormatUtils.dart';
import '../../../med/component/medDetailSheet.dart';
import '../documentSectionHeader.dart';

class MedDocument extends StatelessWidget {
  final List<MedWithStatus> medicines;
  const MedDocument({super.key, required this.medicines});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DocumentSectionHeader(
          title: "Medicines",
          onIconPressed: () {
            print("Add Med clicked");
          },
        ),

        // Doctors list -> InfoCard for each
        ...medicines.map((med) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InfoCard(
              icon: Ph.pill_duotone,
              mainText: med.name,
              subText: TextFormatUtils.formatEnumName(med.medForm.name),
              status: med.entityStatus,
              onTap: () {
                CustomBottomSheet.show(
                    context: context,
                    child: MedDetailSheet(
                      med: Med(
                          id: 0,
                          name: med.name,
                          medForm: med.medForm,
                          healthCondition: med.healthCondition,
                          intakeInterval: med.intakeInterval,
                          startDate: med.startDate,
                          endDate: med.endDate,
                          dosage: med.dosage,
                          stock: med.stock,
                          reminderLimit: med.reminderLimit,
                          instruction: med.instruction),
                    ));
              },
              onEdit: () {},
              onDelete: () {},
            ),
          );
        }),
      ],
    );
  }
}
