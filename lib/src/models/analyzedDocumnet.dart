import 'package:care_sync/src/models/appointmentWithStatus.dart';
import 'package:care_sync/src/models/doctorWithStatus.dart';
import 'package:care_sync/src/models/medWithStatus.dart';
import 'package:care_sync/src/models/vitalWithStatus.dart';

import 'enums/documentType.dart';

class AnalyzedDocument {
  final String documentName;
  final DocumentType documentType;
  final String summary;
  final List<DoctorWithStatus> doctors;
  final List<VitalWithStatus> vitals;
  final List<MedWithStatus> medicines;
  final List<AppointmentWithStatus> appointments;

  AnalyzedDocument({
    required this.documentName,
    required this.documentType,
    required this.summary,
    required this.doctors,
    required this.vitals,
    required this.medicines,
    required this.appointments,
  });

  factory AnalyzedDocument.fromJson(Map<String, dynamic> json) =>
      AnalyzedDocument(
        documentName: json['documentName'],
        documentType: DocumentType.fromJson(json['documentType']),
        summary: json['summary'],
        doctors: (json['doctors'] as List<dynamic>)
            .map((e) => DoctorWithStatus.fromJson(e))
            .toList(),
        vitals: (json['vitals'] as List<dynamic>)
            .map((e) => VitalWithStatus.fromJson(e))
            .toList(),
        medicines: (json['medicines'] as List<dynamic>)
            .map((e) => MedWithStatus.fromJson(e))
            .toList(),
        appointments: (json['appointments'] as List<dynamic>)
            .map((e) => AppointmentWithStatus.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'documentName': documentName,
        'documentType': documentType.toJson(),
        'summary': summary,
        'doctors': doctors.map((e) => e.toJson()).toList(),
        'vitals': vitals.map((e) => e.toJson()).toList(),
        'medicines': medicines.map((e) => e.toJson()).toList(),
        'appointments': appointments.map((e) => e.toJson()).toList(),
      };
}
