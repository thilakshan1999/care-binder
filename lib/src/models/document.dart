import 'doctor.dart';
import 'appointment.dart';
import 'enums/documentType.dart';
import 'med.dart';
import 'vital.dart';

class Document {
  final int? id;
  final String documentName;
  final DocumentType documentType;
  final String summary;
  final List<Doctor> doctors;
  final List<Vital> vitals;
  final List<Med> medicines;
  final List<Appointment> appointments;
  final DateTime updatedTime;

  Document({
    this.id,
    required this.documentName,
    required this.documentType,
    required this.summary,
    required this.doctors,
    required this.vitals,
    required this.medicines,
    required this.appointments,
    required this.updatedTime,
  });

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        id: json['id'],
        documentName: json['documentName'],
        documentType: DocumentType.fromJson(json['documentType']),
        summary: json['summary'],
        doctors: (json['doctors'] as List<dynamic>)
            .map((e) => Doctor.fromJson(e))
            .toList(),
        vitals: (json['vitals'] as List<dynamic>)
            .map((e) => Vital.fromJson(e))
            .toList(),
        medicines: (json['meds'] as List<dynamic>)
            .map((e) => Med.fromJson(e))
            .toList(),
        appointments: (json['appointments'] as List<dynamic>)
            .map((e) => Appointment.fromJson(e))
            .toList(),
        updatedTime: DateTime.parse(json['updatedTime']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'documentName': documentName,
        'documentType': documentType.toJson(),
        'summary': summary,
        'doctors': doctors.map((e) => e.toJson()).toList(),
        'vitals': vitals.map((e) => e.toJson()).toList(),
        'meds': medicines.map((e) => e.toJson()).toList(),
        'appointments': appointments.map((e) => e.toJson()).toList(),
        'updatedTime': updatedTime.toIso8601String(),
      };
}
