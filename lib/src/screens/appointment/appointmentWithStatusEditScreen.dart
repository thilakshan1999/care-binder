import 'package:care_sync/src/bloc/analyzedDocumentBloc.dart';
import 'package:care_sync/src/models/appointmentWithStatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/appBar/appBar.dart';
import '../../component/btn/primaryBtn/primaryBtn.dart';
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
            Expanded(child: Form(key: _formKey, child: SizedBox())),
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
