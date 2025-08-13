import 'package:care_sync/src/models/appointmentWithStatus.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/uim.dart';

import '../../../../component/bottomSheet/bottomSheet.dart';
import '../../../../component/card/InfoCard.dart';
import '../../../../models/appointment.dart';
import '../../../../utils/textFormatUtils.dart';
import '../../../appointment/component/appointmentDetailsSheet.dart';
import '../documentSectionHeader.dart';

class AppointmentDocument extends StatelessWidget {
  final List<AppointmentWithStatus> appointments;
  const AppointmentDocument({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DocumentSectionHeader(
          title: "Appointment",
          onIconPressed: () {
            print("Add Appointment clicked");
          },
        ),

        // Doctors list -> InfoCard for each
        ...appointments.map((appointment) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InfoCard(
              icon: Uim.calender,
              mainText: appointment.name,
              subText: TextFormatUtils.formatEnumName(appointment.type.name),
              status: appointment.entityStatus,
              onTap: () {
                CustomBottomSheet.show(
                    context: context,
                    child: AppointmentDetailSheet(
                        appointment: Appointment(
                            name: appointment.name,
                            type: appointment.type,
                            doctor: appointment.doctor,
                            appointmentDateTime:
                                appointment.appointmentDateTime,
                            id: 0)));
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
