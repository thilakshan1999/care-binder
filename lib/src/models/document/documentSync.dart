import 'package:care_sync/src/models/document/documentDto.dart';

class documentSync {
  final List<DocumentDto> updatedDocuments;
  final List<int> deletedDocumentIds;
  final String serverTime;

  documentSync({
    required this.updatedDocuments,
    required this.deletedDocumentIds,
    required this.serverTime,
  });

  factory documentSync.fromJson(Map<String, dynamic> json) {
    return documentSync(
      updatedDocuments: (json['updated'] as List)
          .map((e) => DocumentDto.fromJson(e))
          .toList(),
      deletedDocumentIds:
          (json['deleted'] as List).map((e) => e as int).toList(),
      serverTime: json['serverTime'] as String,
    );
  }
}
