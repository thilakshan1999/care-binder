import 'package:care_sync/src/bloc/analyzedDocumentBloc.dart';
import 'package:care_sync/src/models/medicine/medWithStatus.dart';
import 'package:care_sync/src/screens/med/medWithStatusEditScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/icons/ph.dart';

import '../../../../component/bottomSheet/bottomSheet.dart';
import '../../../../component/card/InfoCard.dart';
import '../../../../component/dialog/confirmDeleteDialog.dart';
import '../../../../models/enums/entityStatus.dart';
import '../../../../models/medicine/med.dart';
import '../../../../utils/textFormatUtils.dart';
import '../../../med/component/medDetailSheet.dart';
import '../documentSectionHeader.dart';

class MedDocument extends StatelessWidget {
  final List<MedWithStatus>? medicinesWithStatus;
  final List<Med>? medicines;
  final bool isEditable;
  const MedDocument(
      {super.key,
      this.medicinesWithStatus,
      this.medicines,
      this.isEditable = true})
      : assert(
          medicinesWithStatus != null || medicines != null,
          'Either medicinesWithStatus or medicines must be provided',
        );

  @override
  Widget build(BuildContext context) {
    final normalizedMedicines = medicinesWithStatus ??
        medicines!.map((med) {
          return MedWithStatus(
            id: med.id,
            name: med.name,
            medForm: med.medForm,
            healthCondition: med.healthCondition,
            intakeInterval: med.intakeInterval,
            startDate: med.startDate,
            endDate: med.endDate,
            dosage: med.dosage,
            stock: med.stock,
            instruction: med.instruction,
            entityStatus: EntityStatus.SAME,
          );
        }).toList();
    return Column(
      children: [
        if (normalizedMedicines.isNotEmpty)
          DocumentSectionHeader(
            title: "Medicines",
            onIconPressed: () {
              print("Add Med clicked");
            },
          ),

        // Doctors list -> InfoCard for each
        ...normalizedMedicines.map((med) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InfoCard(
              icon: Ph.pill_duotone,
              isEditable: isEditable,
              mainText: med.name,
              subText: med.medForm != null
                  ? TextFormatUtils.formatName(med.medForm!.name)
                  : null,
              status: medicinesWithStatus != null ? med.entityStatus : null,
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
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MedWithStatusEditScreen(
                      med: med,
                      index: normalizedMedicines.indexOf(med),
                    ),
                  ),
                );
              },
              onDelete: () {
                showConfirmDialog(
                  context: context,
                  title: "Delete Medicine",
                  message: "Are you sure you want to delete this medicine?",
                  onConfirm: () {
                    context
                        .read<AnalyzedDocumentBloc>()
                        .deleteMedicine(normalizedMedicines.indexOf(med));
                  },
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
