import 'package:care_sync/src/models/doctorWithStatus.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/map.dart';
import '../../../../component/bottomSheet/bottomSheet.dart';
import '../../../../component/card/InfoCard.dart';
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
              onEdit: () {},
              onDelete: () {},
            ),
          );
        }),
      ],
    );
  }
}
