import 'dart:convert';

class DocumentDto {
  final int id;
  final String documentName;
  final String documentType;
  final String? summary;
  final DateTime? dateOfTest;
  final DateTime? dateOfVisit;
  String? fileUrl;
  final String? fileName;
  final String? fileType;
  final int userId;
  final String? doctorsJson;
  final String? vitalsJson;
  final String? medicinesJson;
  final String? appointmentsJson;
  final DateTime updatedTime;

  DocumentDto({
    required this.id,
    required this.documentName,
    required this.documentType,
    this.summary,
    this.dateOfTest,
    this.dateOfVisit,
    this.fileUrl,
    this.fileName,
    this.fileType,
    required this.userId,
    this.doctorsJson,
    this.vitalsJson,
    this.medicinesJson,
    this.appointmentsJson,
    required this.updatedTime,
  });

  // 🔹 From JSON (from API)
  factory DocumentDto.fromJson(Map<String, dynamic> json) {
    return DocumentDto(
      id: json['id'],
      documentName: json['documentName'],
      documentType: json['documentType'],
      summary: json['summary'],
      dateOfTest: json['dateOfTest'] != null
          ? DateTime.parse(json['dateOfTest'])
          : null,
      dateOfVisit: json['dateOfVisit'] != null
          ? DateTime.parse(json['dateOfVisit'])
          : null,
      fileUrl: json['fileUrl'],
      fileName: json['fileName'],
      fileType: json['fileType'],
      userId: json['userId'],
      doctorsJson: json['doctors'] != null ? jsonEncode(json['doctors']) : null,
      vitalsJson: json['vitals'] != null ? jsonEncode(json['vitals']) : null,
      medicinesJson:
          json['medicines'] != null ? jsonEncode(json['medicines']) : null,
      appointmentsJson: json['appointments'] != null
          ? jsonEncode(json['appointments'])
          : null,
      updatedTime: DateTime.parse(json['updatedTime']),
    );
  }

  // 🔹 To JSON (for sending to API or saving offline)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentName': documentName,
      'documentType': documentType,
      'summary': summary,
      'dateOfTest': dateOfTest?.toIso8601String(),
      'dateOfVisit': dateOfVisit?.toIso8601String(),
      'fileUrl': fileUrl,
      'fileName': fileName,
      'fileType': fileType,
      'userId': userId,
      'doctorsJson': doctorsJson,
      'vitalsJson': vitalsJson,
      'medicinesJson': medicinesJson,
      'appointmentsJson': appointmentsJson,
      'updatedTime': updatedTime.toIso8601String(),
    };
  }
}
