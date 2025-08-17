import 'package:care_sync/src/bloc/analyzedDocumentBloc.dart';
import 'package:care_sync/src/component/dropdown/simpleEnumDropdown.dart';
import 'package:care_sync/src/component/dropdown/simpleObjeckDropdown.dart';
import 'package:care_sync/src/models/analyzedDocument.dart';
import 'package:care_sync/src/models/appointmentWithStatus.dart';
import 'package:care_sync/src/models/doctor.dart';
import 'package:care_sync/src/models/enums/appointmentType.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/appBar/appBar.dart';
import '../../component/btn/primaryBtn/primaryBtn.dart';
import '../../component/datePicker/dateTimePickerField.dart';
import '../../models/enums/entityStatus.dart';

class AppointmentWithStatusEditScreen extends StatefulWidget {
  final AppointmentWithStatus appointment;
  final int index;
  const AppointmentWithStatusEditScreen(
      {super.key, required this.appointment, required this.index});

  @override
  State<AppointmentWithStatusEditScreen> createState() =>
      _MedWithStatusEditScreenState();
}

class _MedWithStatusEditScreenState
    extends State<AppointmentWithStatusEditScreen> {
  late AppointmentWithStatus updatedAppointment;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    updatedAppointment = widget.appointment.copyWith();
  }

  void saveAppointment() {
    if (_formKey.currentState?.validate() ?? false) {
      if (updatedAppointment.id != null) {
        updatedAppointment.entityStatus = EntityStatus.UPDATED;
      }

      context
          .read<AnalyzedDocumentBloc>()
          .updateAppointment(widget.index, updatedAppointment);
      Navigator.pop(context);
    }
  }

  bool get isFormValid => _formKey.currentState?.validate() ?? false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        tittle: "Edit ${updatedAppointment.name}",
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
                child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          //Appointment Type
                          SimpleEnumDropdownField(
                            labelText: "Appointment Type",
                            initialValue: updatedAppointment.type,
                            values: AppointmentType.values,
                            onChanged: (value) {
                              updatedAppointment.type = value!;
                            },
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          BlocBuilder<AnalyzedDocumentBloc, AnalyzedDocument?>(
                              builder: (context, document) {
                            return SimpleObjectDropdownField<Doctor>(
                              labelText: "Doctor",
                              clearOption: true,
                              initialValue: updatedAppointment.doctor,
                              values: document!.doctorsPlain,
                              displayText: (doctor) => doctor.name,
                              onChanged: (doctor) {
                                updatedAppointment.doctor = doctor;
                              },
                            );
                          }),

                          const SizedBox(
                            height: 20,
                          ),

                          DateTimePickerField(
                            labelText: "Appointment Date & Time",
                            initialDateTime:
                                updatedAppointment.appointmentDateTime,
                            showTime: true,
                            onChanged: (dateTime) {
                              setState(() {
                                updatedAppointment.appointmentDateTime =
                                    dateTime!;
                              });
                            },
                          )
                        ],
                      ),
                    ))),
            PrimaryBtn(
              label: 'Save',
              onPressed: saveAppointment,
            ),
          ],
        ),
      ),
    );
  }
}
