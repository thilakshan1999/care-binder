import 'package:care_sync/src/models/appointmentWithStatus.dart';
import 'package:care_sync/src/screens/appointment/appointmentWithStatusEditScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/icons/uim.dart';

import '../../../../bloc/analyzedDocumentBloc.dart';
import '../../../../component/bottomSheet/bottomSheet.dart';
import '../../../../component/card/InfoCard.dart';
import '../../../../component/dialog/confirmDeleteDialog.dart';
import '../../../../models/appointment.dart';
import '../../../../utils/textFormatUtils.dart';
import '../../../appointment/component/appointmentDetailsSheet.dart';
import '../documentSectionHeader.dart';

class AppointmentDocument extends StatelessWidget {
  final List<AppointmentWithStatus> appointments;
  final bool isEditable;
  const AppointmentDocument(
      {super.key, required this.appointments, this.isEditable = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (appointments.isNotEmpty)
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
              isEditable: isEditable,
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
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AppointmentWithStatusEditScreen(
                      appointment: appointment,
                      index: appointments.indexOf(appointment),
                    ),
                  ),
                );
              },
              onDelete: () {
                showConfirmDeleteDialog(
                  context: context,
                  title: "Delete Appointment",
                  message: "Are you sure you want to delete this appointment?",
                  onConfirm: () {
                    context
                        .read<AnalyzedDocumentBloc>()
                        .deleteAppointment(appointments.indexOf(appointment));
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
