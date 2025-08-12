import 'package:care_sync/src/models/appointmentWithStatus.dart';
import 'package:care_sync/src/models/doctorWithStatus.dart';
import 'package:care_sync/src/models/medWithStatus.dart';
import 'package:care_sync/src/models/vitalWithStatus.dart';

import 'enums/documentType.dart';

class AnalyzedDocument {
  String documentName;
  DocumentType documentType;
  String summary;
  // final List<DoctorWithStatus> doctors;
  // final List<VitalWithStatus> vitals;
  // final List<MedWithStatus> medicines;
  // final List<AppointmentWithStatus> appointments;

  AnalyzedDocument({
    required this.documentName,
    required this.documentType,
    required this.summary,
    // required this.doctors,
    // required this.vitals,
    // required this.medicines,
    // required this.appointments,
  });

  factory AnalyzedDocument.fromJson(Map<String, dynamic> json) =>
      AnalyzedDocument(
        documentName: json['documentName'],
        documentType: DocumentType.fromJson(json['documentType']),
        summary: json['summary'] ?? "",
        // doctors: (json['doctors'] as List<dynamic>)
        //     .map((e) => DoctorWithStatus.fromJson(e))
        //     .toList(),
        // vitals: (json['vitals'] as List<dynamic>)
        //     .map((e) => VitalWithStatus.fromJson(e))
        //     .toList(),
        // medicines: (json['medicines'] as List<dynamic>)
        //     .map((e) => MedWithStatus.fromJson(e))
        //     .toList(),
        // appointments: (json['appointments'] as List<dynamic>)
        //     .map((e) => AppointmentWithStatus.fromJson(e))
        //     .toList(),
      );

  Map<String, dynamic> toJson() => {
        'documentName': documentName,
        'documentType': documentType.toJson(),
        'summary': summary,
        // 'doctors': doctors.map((e) => e.toJson()).toList(),
        // 'vitals': vitals.map((e) => e.toJson()).toList(),
        // 'medicines': medicines.map((e) => e.toJson()).toList(),
        // 'appointments': appointments.map((e) => e.toJson()).toList(),
      };
}

final sampleAnalyzedDocument = AnalyzedDocument(
  documentName: "John Doe Medical Report",
  documentType: DocumentType.MEDICAL_REPORT,
  summary: "Patient presents with mild fever and cough. "
      "Prescribed medication and follow-up in 1 week.",
  // doctors: [
  //   DoctorWithStatus(
  //     name: "Dr. Amanda Lewis",
  //     specialization: "General Practitioner",
  //     status: "verified",
  //   ),
  //   DoctorWithStatus(
  //     name: "Dr. Ravi Kumar",
  //     specialization: "Cardiologist",
  //     status: "pending",
  //   ),
  // ],
  // vitals: [
  //   VitalWithStatus(
  //     name: "Blood Pressure",
  //     value: "120/80 mmHg",
  //     status: "verified",
  //   ),
  //   VitalWithStatus(
  //     name: "Heart Rate",
  //     value: "76 bpm",
  //     status: "verified",
  //   ),
  // ],
  // medicines: [
  //   MedWithStatus(
  //     name: "Paracetamol 500mg",
  //     dosage: "1 tablet every 6 hours",
  //     status: "verified",
  //   ),
  //   MedWithStatus(
  //     name: "Amoxicillin 250mg",
  //     dosage: "1 capsule every 8 hours",
  //     status: "pending",
  //   ),
  // ],
  // appointments: [
  //   AppointmentWithStatus(
  //     date: DateTime.now().add(const Duration(days: 7)),
  //     purpose: "Follow-up consultation",
  //     status: "scheduled",
  //   ),
  // ],
);
