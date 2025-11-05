import 'package:care_sync/src/models/appointment/appointmentWithStatus.dart';
import 'package:care_sync/src/models/doctor/doctor.dart';
import 'package:care_sync/src/models/doctor/doctorWithStatus.dart';
import 'package:care_sync/src/models/enums/appointmentType.dart';
import 'package:care_sync/src/models/enums/entityStatus.dart';
import 'package:care_sync/src/models/enums/intakeInstruction.dart';
import 'package:care_sync/src/models/enums/medForm.dart';
import 'package:care_sync/src/models/medicine/medWithStatus.dart';
import 'package:care_sync/src/models/vital/vitalMeasurement.dart';
import 'package:care_sync/src/models/vital/vitalWithStatus.dart';
import '../enums/documentType.dart';

class AnalyzedDocument {
  String documentName;
  DocumentType documentType;
  List<DocumentType> documentTypeList;
  String summary;
  List<DoctorWithStatus> doctors;
  List<VitalWithStatus> vitals;
  List<MedWithStatus> medicines;
  List<AppointmentWithStatus> appointments;

  AnalyzedDocument({
    required this.documentName,
    required this.documentType,
    required this.documentTypeList,
    required this.summary,
    required this.doctors,
    required this.vitals,
    required this.medicines,
    required this.appointments,
  });

  factory AnalyzedDocument.fromJson(Map<String, dynamic> json) =>
      AnalyzedDocument(
        documentName: json['documentName'] ?? "",
        documentType: DocumentType.fromJson(json['documentType']),
        documentTypeList: (json['documentTypeList'] as List<dynamic>?)
                ?.map((e) => DocumentType.fromJson(e))
                .toList() ??
            [],
        summary: json['summary'] ?? "",
        doctors: (json['doctors'] as List<dynamic>?)
                ?.map((e) => DoctorWithStatus.fromJson(e))
                .toList() ??
            [],
        vitals: (json['vitals'] as List<dynamic>?)
                ?.map((e) => VitalWithStatus.fromJson(e))
                .toList() ??
            [],
        medicines: (json['meds'] as List<dynamic>?)
                ?.map((e) => MedWithStatus.fromJson(e))
                .toList() ??
            [],
        appointments: (json['appointments'] as List<dynamic>?)
                ?.map((e) => AppointmentWithStatus.fromJson(e))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'documentName': documentName,
        'documentType': documentType.toJson(),
        'documentTypeList': documentTypeList.map((e) => e.toJson()).toList(),
        'summary': summary,
        'doctors': doctors.map((e) => e.toJson()).toList(),
        'vitals': vitals.map((e) => e.toJson()).toList(),
        'meds': medicines.map((e) => e.toJson()).toList(),
        'appointments': appointments.map((e) => e.toJson()).toList(),
      };

  AnalyzedDocument copyWith({
    String? documentName,
    DocumentType? documentType,
    List<DocumentType>? documentTypeList,
    String? summary,
    List<DoctorWithStatus>? doctors,
    List<MedWithStatus>? medicines,
    List<AppointmentWithStatus>? appointments,
    List<VitalWithStatus>? vitals,
  }) {
    return AnalyzedDocument(
      documentName: documentName ?? this.documentName,
      documentType: documentType ?? this.documentType,
      documentTypeList: documentTypeList ?? this.documentTypeList,
      summary: summary ?? this.summary,
      doctors: doctors ?? this.doctors,
      medicines: medicines ?? this.medicines,
      appointments: appointments ?? this.appointments,
      vitals: vitals ?? this.vitals,
    );
  }

  List<Doctor> get doctorsPlain => doctors.map((dws) {
        return Doctor(
          id: dws.id ?? 0,
          name: dws.name,
          specialization: dws.specialization,
          phoneNumber: dws.phoneNumber,
          email: dws.email,
          address: dws.address,
        );
      }).toList();
}

final sampleAnalyzedDocument = AnalyzedDocument(
  documentName: "John Doe Medical Report",
  documentType: DocumentType.MEDICAL_REPORT,
  documentTypeList: [],
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
  vitals: [
    VitalWithStatus(
      name: "Blood Pressure",
      measurements: [VitalMeasurement(dateTime: DateTime.now(), value: "420")],
      entityStatus: EntityStatus.NEW,
    ),
    VitalWithStatus(
      name: "Heart Rate",
      unit: "kg",
      remindDuration: const Duration(hours: 2),
      startDateTime: DateTime.now(),
      measurements: [VitalMeasurement(dateTime: DateTime.now(), value: "40")],
      entityStatus: EntityStatus.SAME,
    ),
  ],
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
  appointments: [
    AppointmentWithStatus(
        name: "Appointment 1",
        type: AppointmentType.CHECKUP,
        appointmentDateTime: DateTime.now(),
        entityStatus: EntityStatus.NEW),
    AppointmentWithStatus(
        name: "Appointment 2",
        type: AppointmentType.CONSULTATION,
        appointmentDateTime: DateTime.now(),
        doctor: Doctor(
          name: "Dr.Ravi Kumar",
          specialization: "Cardiologist",
          id: 0,
        ),
        entityStatus: EntityStatus.NEW)
  ],
);

final sampleAnalyzedDocumentJson = {
  "documentName": "John Doe Medical Report",
  "documentType": "MEDICAL_REPORT",
  "documentTypeList": ["MEDICAL_REPORT"],
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
  "meds": [
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
  ],
  "appointments": [
    {
      "name": "Appointment 1",
      "type": "CHECKUP",
      "appointmentDateTime": "2025-08-13T08:00:00Z",
      "entityStatus": "NEW"
    },
    {
      "name": "Appointment 2",
      "type": "CONSULTATION",
      "appointmentDateTime": "2025-08-13T08:00:00Z",
      "doctor": {
        "name": "Dr.Ravi Kumar",
        "specialization": "Cardiologist",
        "id": 0
      },
      "entityStatus": "NEW"
    }
  ],
  "vitals": [
    {
      "name": "Blood Pressure",
      "measurements": [
        {"dateTime": "2025-08-13T08:00:00.000Z", "value": "420"}
      ],
      "entityStatus": "NEW"
    },
    {
      "name": "Heart Rate",
      "unit": "kg",
      "remindDuration": "PT2H",
      "startDateTime": "2025-08-13T08:00:00.000Z",
      "measurements": [
        {"dateTime": "2025-08-13T08:00:00.000Z", "value": "40"}
      ],
      "entityStatus": "SAME"
    }
  ]
};
