import 'package:care_sync/src/bloc/analyzedDocumentBloc.dart';
import 'package:care_sync/src/models/doctor/doctorWithStatus.dart';
import 'package:care_sync/src/screens/doctor/doctorWithStatusEditScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/icons/map.dart';
import '../../../../component/bottomSheet/bottomSheet.dart';
import '../../../../component/card/InfoCard.dart';
import '../../../../component/dialog/confirmDeleteDialog.dart';
import '../../../../models/doctor/doctor.dart';
import '../../../../models/enums/entityStatus.dart';
import '../../../doctor/component/doctorProfileSheet.dart';
import '../documentSectionHeader.dart';

class DoctorDocument extends StatelessWidget {
  final List<DoctorWithStatus>? doctorsWithStatus;
  final List<Doctor>? doctors;
  final bool isEditable;
  const DoctorDocument({
    super.key,
    this.doctorsWithStatus,
    this.doctors,
    this.isEditable = true,
  }) : assert(
          doctorsWithStatus != null || doctors != null,
          'Either doctorsWithStatus or doctors must be provided',
        );

  @override
  Widget build(BuildContext context) {
    final normalizedDoctors = doctorsWithStatus ??
        doctors!.map((doc) {
          return DoctorWithStatus(
            id: doc.id,
            name: doc.name,
            specialization: doc.specialization,
            phoneNumber: doc.phoneNumber,
            email: doc.email,
            address: doc.address,
            entityStatus: EntityStatus.SAME,
          );
        }).toList();

    return Column(
      children: [
        if (normalizedDoctors.isNotEmpty)
          DocumentSectionHeader(
            title: "Doctors",
            onIconPressed: () {
              print("Add doctor clicked");
            },
          ),

        // Doctors list -> InfoCard for each
        ...normalizedDoctors.map((doctor) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InfoCard(
              icon: Map.doctor,
              isEditable: isEditable,
              mainText: doctor.name,
              subText: doctor.specialization ?? "Specialization not available",
              status: doctorsWithStatus != null ? doctor.entityStatus : null,
              onTap: () {
                CustomBottomSheet.show(
                    context: context,
                    child: DoctorProfileSheet(
                      doctor: Doctor(
                          name: doctor.name,
                          specialization: doctor.specialization,
                          phoneNumber: doctor.phoneNumber,
                          email: doctor.email,
                          address: doctor.address,
                          id: 0),
                    ));
              },
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DoctorWithStatusEditScreen(
                      doctor: doctor,
                      index: normalizedDoctors.indexOf(doctor),
                    ),
                  ),
                );
              },
              onDelete: () {
                showConfirmDialog(
                  context: context,
                  title: "Delete Doctor",
                  message: "Are you sure you want to delete this doctor?",
                  onConfirm: () {
                    context
                        .read<AnalyzedDocumentBloc>()
                        .deleteDoctor(normalizedDoctors.indexOf(doctor));
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
