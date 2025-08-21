import 'package:care_sync/src/models/vital/vitalWithStatus.dart';
import 'package:care_sync/src/screens/vital/vitalWithStatusEditScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/icons/ri.dart';

import '../../../../bloc/analyzedDocumentBloc.dart';
import '../../../../component/bottomSheet/bottomSheet.dart';
import '../../../../component/card/InfoCard.dart';
import '../../../../component/dialog/confirmDeleteDialog.dart';
import '../../../../models/enums/entityStatus.dart';
import '../../../../models/vital/vital.dart';
import '../../../vital/component/vitalDetailSheet.dart';
import '../documentSectionHeader.dart';

class VitalDocument extends StatelessWidget {
  final List<VitalWithStatus>? vitalsWithStatus;
  final List<Vital>? vitals;
  final bool isEditable;
  const VitalDocument(
      {super.key, this.vitalsWithStatus, this.vitals, this.isEditable = true})
      : assert(
          vitalsWithStatus != null || vitals != null,
          'Either vitalsWithStatus or vital must be provided',
        );

  @override
  Widget build(BuildContext context) {
    final normalizedVitals = vitalsWithStatus ??
        vitals!.map((vital) {
          return VitalWithStatus(
            id: vital.id,
            name: vital.name,
            unit: vital.unit,
            remindDuration: vital.remindDuration,
            startDateTime: vital.startDateTime,
            measurements: vital.measurements,
            entityStatus: EntityStatus.SAME,
          );
        }).toList();

    return Column(
      children: [
        if (normalizedVitals.isNotEmpty)
          DocumentSectionHeader(
            title: "Vitals",
            onIconPressed: () {
              print("Add vita; clicked");
            },
          ),
        ...normalizedVitals.map((vital) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InfoCard(
              icon: Ri.heart_pulse_fill,
              isEditable: isEditable,
              mainText: vital.name,
              subText: null,
              status: vitalsWithStatus != null ? vital.entityStatus : null,
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
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VitalWithStatusEditScreen(
                      vital: vital,
                      index: normalizedVitals.indexOf(vital),
                    ),
                  ),
                );
              },
              onDelete: () {
                showConfirmDeleteDialog(
                  context: context,
                  title: "Delete Vital",
                  message: "Are you sure you want to delete this vital?",
                  onConfirm: () {
                    context
                        .read<AnalyzedDocumentBloc>()
                        .deleteVitals(normalizedVitals.indexOf(vital));
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
