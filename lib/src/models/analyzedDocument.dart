import 'package:care_sync/src/models/appointmentWithStatus.dart';
import 'package:care_sync/src/models/doctorWithStatus.dart';
import 'package:care_sync/src/models/enums/entityStatus.dart';
import 'package:care_sync/src/models/enums/intakeInstruction.dart';
import 'package:care_sync/src/models/enums/medForm.dart';
import 'package:care_sync/src/models/medWithStatus.dart';
import 'package:care_sync/src/models/vitalWithStatus.dart';
import 'enums/documentType.dart';

class AnalyzedDocument {
  String documentName;
  DocumentType documentType;
  String summary;
  List<DoctorWithStatus> doctors;
  // final List<VitalWithStatus> vitals;
  List<MedWithStatus> medicines;
  // final List<AppointmentWithStatus> appointments;

  AnalyzedDocument({
    required this.documentName,
    required this.documentType,
    required this.summary,
    required this.doctors,
    // required this.vitals,
    required this.medicines,
    // required this.appointments,
  });

  factory AnalyzedDocument.fromJson(Map<String, dynamic> json) =>
      AnalyzedDocument(
        documentName: json['documentName'] ?? "",
        documentType: DocumentType.fromJson(json['documentType']),
        summary: json['summary'] ?? "",
        doctors: (json['doctors'] as List<dynamic>?)
                ?.map((e) => DoctorWithStatus.fromJson(e))
                .toList() ??
            [],
        // vitals: (json['vitals'] as List<dynamic>?)
        //         ?.map((e) => VitalWithStatus.fromJson(e))
        //         .toList() ??
        //     [],
        medicines: (json['medicines'] as List<dynamic>?)
                ?.map((e) => MedWithStatus.fromJson(e))
                .toList() ??
            [],
        // appointments: (json['appointments'] as List<dynamic>?)
        //         ?.map((e) => AppointmentWithStatus.fromJson(e))
        //         .toList() ??
        //     [],
      );

  Map<String, dynamic> toJson() => {
        'documentName': documentName,
        'documentType': documentType.toJson(),
        'summary': summary,
        'doctors': doctors.map((e) => e.toJson()).toList(),
        // 'vitals': vitals.map((e) => e.toJson()).toList(),
        'medicines': medicines.map((e) => e.toJson()).toList(),
        // 'appointments': appointments.map((e) => e.toJson()).toList(),
      };
}

final sampleAnalyzedDocument = AnalyzedDocument(
  documentName: "John Doe Medical Report",
  documentType: DocumentType.MEDICAL_REPORT,
  summary: "Patient presents with mild fever and cough. "
      "Prescribed medication and follow-up in 1 week.",
  doctors: [
    DoctorWithStatus(
      id: null,
      name: "Dr. Amanda Lewis",
      specialization: "General Practitioner",
      phoneNumber: "0776932111",
      email: "thlak@gmail.com",
      address: "jaffna",
      entityStatus: EntityStatus.NEW,
    ),
    DoctorWithStatus(
      name: "Dr. Ravi Kumar",
      specialization: "Cardiologist",
      entityStatus: EntityStatus.NEW,
    ),
  ],
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
  medicines: [
    MedWithStatus(
      name: "Paracetamol",
      dosage: "1 tablet",
      medForm: MedForm.TABLET,
      startDate: DateTime.now(),
      entityStatus: EntityStatus.NEW,
    ),
    MedWithStatus(
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
      entityStatus: EntityStatus.UPDATED,
    ),
  ],
  // appointments: [
  //   AppointmentWithStatus(
  //     date: DateTime.now().add(const Duration(days: 7)),
  //     purpose: "Follow-up consultation",
  //     status: "scheduled",
  //   ),
  // ],
);

final sampleAnalyzedDocumentJson = {
  "documentName": "John Doe Medical Report",
  "documentType": "MEDICAL_REPORT",
  "summary":
      "Patient presents with mild fever and cough. Prescribed medication and follow-up in 1 week.",
  "doctors": [
    {
      "id": null,
      "name": "Dr. Amanda Lewis",
      "specialization": "General Practitioner",
      "phoneNumber": "0776932111",
      "email": "thlak@gmail.com",
      "address": "jaffna",
      "entityStatus": "NEW"
    },
    {
      "id": null,
      "name": "Dr. Ravi Kumar",
      "specialization": "Cardiologist",
      "phoneNumber": null,
      "email": null,
      "address": null,
      "entityStatus": "NEW"
    }
  ],
  "medicines": [
    {
      "id": null,
      "name": "Paracetamol",
      "dosage": "1 tablet",
      "medForm": "TABLET",
      "startDate": "2025-08-12T00:00:00.000Z",
      "endDate": null,
      "healthCondition": null,
      "intakeInterval": null,
      "stock": null,
      "reminderLimit": null,
      "instruction": null,
      "entityStatus": "NEW"
    },
    {
      "id": null,
      "name": "Amoxicillin",
      "dosage": "1 capsule",
      "medForm": "CAPSULE",
      "startDate": "2025-08-12T00:00:00.000Z",
      "endDate": "2025-08-12T00:00:00.000Z",
      "healthCondition": "fever",
      "intakeInterval": "PT1H",
      "stock": 10,
      "reminderLimit": 5,
      "instruction": "BEFORE_EAT",
      "entityStatus": "UPDATED"
    }
  ]
};
