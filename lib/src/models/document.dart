import 'doctor.dart';
import 'appointment.dart';
import 'enums/appointmentType.dart';
import 'enums/documentType.dart';
import 'enums/intakeInstruction.dart';
import 'enums/medForm.dart';
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
        medicines: (json['medicines'] as List<dynamic>)
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

final sampleDocument = Document(
  id: 0,
  documentName: "John Doe Medical Report",
  documentType: DocumentType.MEDICAL_REPORT,
  summary: "Patient presents with mild fever and cough. "
      "Prescribed medication and follow-up in 1 week.",
  doctors: [
    Doctor(
      id: 0,
      name: "Dr. Amanda Lewis",
      specialization: "General Practitioner",
      phoneNumber: "0776932111",
      email: "thlak@gmail.com",
      address: "jaffna",
    ),
    Doctor(
      id: 0,
      name: "Dr. Ravi Kumar",
      specialization: "Cardiologist",
    ),
  ],
  vitals: [
    Vital(
      id: 0,
      name: "Blood Pressure",
      measurements: [],
    ),
    Vital(
      id: 0,
      name: "Heart Rate",
      unit: "kg",
      remindDuration: const Duration(hours: 2),
      startDateTime: DateTime.now(),
      measurements: [],
    ),
  ],
  medicines: [
    Med(
      id: 0,
      name: "Paracetamol",
      dosage: "1 tablet",
      medForm: MedForm.TABLET,
      startDate: DateTime.now(),
    ),
    Med(
      id: 0,
      name: "Amoxicillin",
      dosage: "1 capsule",
      healthCondition: "fever",
      intakeInterval: const Duration(hours: 1),
      medForm: MedForm.CAPSULE,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      stock: 10,
      reminderLimit: 5,
      instruction: IntakeInstruction.BEFORE_EAT,
    ),
  ],
  appointments: [
    Appointment(
      id: 0,
      name: "Appointment 1",
      type: AppointmentType.CHECKUP,
      appointmentDateTime: DateTime.now(),
    ),
    Appointment(
      id: 0,
      name: "Appointment 2",
      type: AppointmentType.CONSULTATION,
      appointmentDateTime: DateTime.now(),
      doctor: Doctor(
        name: "Dr.Ravi Kumar",
        specialization: "Cardiologist",
        id: 0,
      ),
    )
  ],
  updatedTime: DateTime.now(),
);
