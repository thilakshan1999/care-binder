import 'package:care_sync/src/models/document/analyzedDocument.dart';
import 'package:care_sync/src/models/appointment/appointmentWithStatus.dart';
import 'package:care_sync/src/models/medicine/medWithStatus.dart';
import 'package:care_sync/src/models/vital/vitalWithStatus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/doctor/doctorWithStatus.dart';

class AnalyzedDocumentBloc extends Cubit<AnalyzedDocument?> {
  AnalyzedDocumentBloc() : super(null);

  void setDocument(AnalyzedDocument doc) => emit(doc);

  // ✅ Clear state
  void clear() => emit(null);

  //Doctor
  void updateDoctor(int index, DoctorWithStatus updatedDoctor) {
    if (state == null) return;
    final updatedDoctors = List<DoctorWithStatus>.from(state!.doctors);
    updatedDoctors[index] = updatedDoctor;
    emit(state!.copyWith(doctors: updatedDoctors));
  }

  void deleteDoctor(int index) {
    if (state == null) return;
    final updatedDoctors = List<DoctorWithStatus>.from(state!.doctors)
      ..removeAt(index);

    emit(state!.copyWith(doctors: updatedDoctors));
  }

  // Med
  void updateMed(int index, MedWithStatus updatedMed) {
    if (state == null) return;
    final updatedMedicines = List<MedWithStatus>.from(state!.medicines);
    updatedMedicines[index] = updatedMed;
    emit(state!.copyWith(medicines: updatedMedicines));
  }

  void deleteMedicine(int index) {
    if (state == null) return;
    final updatedMedicine = List<MedWithStatus>.from(state!.medicines)
      ..removeAt(index);

    emit(state!.copyWith(medicines: updatedMedicine));
  }

//vitals
  void updateVitals(int index, VitalWithStatus updatedVital) {
    if (state == null) return;
    final updatedVitals = List<VitalWithStatus>.from(state!.vitals);
    updatedVitals[index] = updatedVital;
    emit(state!.copyWith(vitals: updatedVitals));
  }

  void deleteVitals(int index) {
    if (state == null) return;
    final updatedVitals = List<VitalWithStatus>.from(state!.vitals)
      ..removeAt(index);

    emit(state!.copyWith(vitals: updatedVitals));
  }

  //Appointment
  void updateAppointment(int index, AppointmentWithStatus updatedAppointment) {
    if (state == null) return;
    final updatedAppointments =
        List<AppointmentWithStatus>.from(state!.appointments);
    updatedAppointments[index] = updatedAppointment;
    emit(state!.copyWith(appointments: updatedAppointments));
  }

  void deleteAppointment(int index) {
    if (state == null) return;
    final updatedAppointment =
        List<AppointmentWithStatus>.from(state!.appointments)..removeAt(index);

    emit(state!.copyWith(appointments: updatedAppointment));
  }
}
