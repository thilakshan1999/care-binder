import 'package:care_sync/src/models/vitalWithStatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/icons/ri.dart';

import '../../../../bloc/analyzedDocumentBloc.dart';
import '../../../../component/bottomSheet/bottomSheet.dart';
import '../../../../component/card/InfoCard.dart';
import '../../../../component/dialog/confirmDeleteDialog.dart';
import '../../../../models/vital.dart';
import '../../../vital/component/vitalDetailSheet.dart';
import '../documentSectionHeader.dart';

class VitalDocument extends StatelessWidget {
  final List<VitalWithStatus> vitals;
  const VitalDocument({super.key, required this.vitals});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (vitals.isNotEmpty)
          DocumentSectionHeader(
            title: "Vitals",
            onIconPressed: () {
              print("Add vita; clicked");
            },
          ),
        ...vitals.map((vital) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InfoCard(
              icon: Ri.heart_pulse_fill,
              mainText: vital.name,
              subText: null,
              status: vital.entityStatus,
              onTap: () {
                CustomBottomSheet.show(
                    context: context,
                    child: VitalDetailSheet(
                      vital: Vital(
                          id: 0,
                          name: vital.name,
                          remindDuration: vital.remindDuration,
                          startDateTime: vital.startDateTime,
                          unit: vital.unit,
                          measurements: vital.measurements),
                    ));
              },
              onEdit: () {},
              onDelete: () {
                showConfirmDeleteDialog(
                  context: context,
                  title: "Delete Vital",
                  message: "Are you sure you want to delete this vital?",
                  onConfirm: () {
                    context
                        .read<AnalyzedDocumentBloc>()
                        .deleteVitals(vitals.indexOf(vital));
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
