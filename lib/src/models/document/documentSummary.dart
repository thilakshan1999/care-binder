import '../enums/documentType.dart';

class DocumentSummary {
  final int id;
  final String documentName;
  final DocumentType documentType;
  final String summary;
  final DateTime updatedTime;
  final DateTime? dateOfTest;
  final DateTime? dateOfVisit;

  DocumentSummary({
    required this.id,
    required this.documentName,
    required this.documentType,
    required this.summary,
    required this.updatedTime,
    this.dateOfTest,
    this.dateOfVisit,
  });

  factory DocumentSummary.fromJson(Map<String, dynamic> json) {
    return DocumentSummary(
      id: json['id'],
      documentName: json['documentName'],
      documentType: DocumentType.fromJson(json['documentType']),
      summary: json['summary'],
      updatedTime: DateTime.parse(json['updatedTime']),
      dateOfTest: json['dateOfTest'] != null
          ? DateTime.parse(json['dateOfTest'])
          : null,
      dateOfVisit: json['dateOfVisit'] != null
          ? DateTime.parse(json['dateOfVisit'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentName': documentName,
      'documentType': documentType.toJson(),
      'summary': summary,
      'updatedTime': updatedTime.toIso8601String(),
      'dateOfTest': dateOfTest?.toIso8601String(),
      'dateOfVisit': dateOfVisit?.toIso8601String()
    };
  }
}

List<DocumentSummary> mockDocumentSummaries = [
  DocumentSummary(
    id: 1,
    documentName: "Passport",
    documentType: DocumentType.LAB_REPORT,
    summary: "Passport copy with first and last page.",
    updatedTime: DateTime.now().subtract(Duration(days: 2)),
  ),
  DocumentSummary(
    id: 2,
    documentName: "Bank Statement",
    documentType: DocumentType.DISCHARGE_SUMMARY,
    summary: "Last 6 months of bank transactions.",
    updatedTime: DateTime.now().subtract(Duration(days: 5)),
  ),
  DocumentSummary(
    id: 3,
    documentName: "Medical Report",
    documentType: DocumentType.PRESCRIPTION,
    summary: "Annual health checkup report from Sunshine Hospital.",
    updatedTime: DateTime.now().subtract(Duration(hours: 12)),
  ),
  DocumentSummary(
    id: 4,
    documentName: "Employment Letter",
    documentType: DocumentType.PRESCRIPTION,
    summary: "Verification of employment at Tech Corp.",
    updatedTime: DateTime.now().subtract(Duration(days: 10)),
  ),
  DocumentSummary(
    id: 5,
    documentName: "Utility Bill",
    documentType: DocumentType.TEST_RESULT,
    summary: "Electricity bill issued in July 2025.",
    updatedTime: DateTime.now(),
  ),
];
