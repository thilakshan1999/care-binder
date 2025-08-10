import 'enums/documentType.dart';

class DocumentSummary {
  final int id;
  final String documentName;
  final DocumentType documentType;
  final String summary;
  final DateTime updatedTime;

  DocumentSummary({
    required this.id,
    required this.documentName,
    required this.documentType,
    required this.summary,
    required this.updatedTime,
  });

  factory DocumentSummary.fromJson(Map<String, dynamic> json) {
    return DocumentSummary(
      id: json['id'],
      documentName: json['documentName'],
      documentType: DocumentType.fromJson(json['documentType']),
      summary: json['summary'],
      updatedTime: DateTime.parse(json['updatedTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentName': documentName,
      'documentType': documentType.toJson(),
      'summary': summary,
      'updatedTime': updatedTime.toIso8601String(),
    };
  }
}
