import 'package:care_sync/src/bloc/analyzedDocumentBloc.dart';
import 'package:care_sync/src/models/doctorWithStatus.dart';
import 'package:care_sync/src/screens/doctor/doctorWithStatusEditScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/icons/map.dart';
import '../../../../component/bottomSheet/bottomSheet.dart';
import '../../../../component/card/InfoCard.dart';
import '../../../../component/dialog/confirmDeleteDialog.dart';
import '../../../../models/doctor.dart';
import '../../../doctor/component/doctorProfileSheet.dart';
import '../documentSectionHeader.dart';

class DoctorDocument extends StatelessWidget {
  final List<DoctorWithStatus> doctors;
  const DoctorDocument({super.key, required this.doctors});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (doctors.isNotEmpty)
          DocumentSectionHeader(
            title: "Doctors",
            onIconPressed: () {
              print("Add doctor clicked");
            },
          ),

        // Doctors list -> InfoCard for each
        ...doctors.map((doctor) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InfoCard(
              icon: Map.doctor,
              mainText: doctor.name,
              subText: doctor.specialization ?? "Specialization not available",
              status: doctor.entityStatus,
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
                      index: doctors.indexOf(doctor),
                    ),
                  ),
                );
              },
              onDelete: () {
                showConfirmDeleteDialog(
                  context: context,
                  title: "Delete Doctor",
                  message: "Are you sure you want to delete this doctor?",
                  onConfirm: () {
                    context
                        .read<AnalyzedDocumentBloc>()
                        .deleteDoctor(doctors.indexOf(doctor));
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
