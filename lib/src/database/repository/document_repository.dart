import 'dart:convert';

import 'package:care_sync/src/database/app_database.dart';
import 'package:care_sync/src/models/document/documentDto.dart';
import 'package:care_sync/src/models/document/documentSummary.dart';
import 'package:care_sync/src/models/enums/documentType.dart';
import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocumentRepository {
  final AppDatabase db;

  DocumentRepository(this.db);

  Future<void> saveDocuments(List<DocumentDto> documents) async {
    await db.batch((batch) {
      for (final doc in documents) {
        batch.insert(
          db.documentTable,
          DocumentTableCompanion(
            id: Value(doc.id),
            documentName: Value(doc.documentName),
            documentType: Value(doc.documentType),
            summary: Value(doc.summary),
            dateOfTest: Value(doc.dateOfTest),
            dateOfVisit: Value(doc.dateOfVisit),
            updatedTime: Value(doc.updatedTime),
            fileUrl: Value(doc.fileUrl),
            fileName: Value(doc.fileName),
            fileType: Value(doc.fileType),
            userId: Value(doc.userId),
            doctorsJson: Value(doc.doctorsJson),
            vitalsJson: Value(doc.vitalsJson),
            medicinesJson: Value(doc.medicinesJson),
            appointmentsJson: Value(doc.appointmentsJson),
            isUpdated: const Value(false),
            isDeleted: const Value(false),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<void> deleteDocumentsByIds(List<int> ids) async {
    if (ids.isEmpty) return;

    await (db.delete(db.documentTable)..where((tbl) => tbl.id.isIn(ids))).go();
  }

  Future<List<DocumentSummary>> getDocumentsByUser(int userId) async {
    final rows = await (db.select(db.documentTable)
          ..where(
            (tbl) => tbl.userId.equals(userId) & tbl.isDeleted.equals(false),
          ))
        .get();

    return rows
        .map((row) => DocumentSummary(
              id: row.id,
              documentName: row.documentName,
              documentType: DocumentType.values.firstWhere(
                (e) => e.name == row.documentType,
              ),
              summary: row.summary ?? '',
              updatedTime: row.updatedTime,
              dateOfTest: row.dateOfTest,
              dateOfVisit: row.dateOfVisit,
            ))
        .toList();
  }

  Future<DocumentTableData?> getDocumentById(int id) async {
    return (db.select(db.documentTable)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> saveLastSyncTime(String serverTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("lastSyncTime", serverTime);

    print("✅ Saved last sync time: $serverTime");
  }

  Future<DateTime?> getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();

    final timeString = prefs.getString("lastSyncTime");

    if (timeString == null) {
      return DateTime.now().toUtc().subtract(const Duration(days: 3650));
    }

    try {
      return DateTime.parse(timeString);
    } catch (e) {
      print("❌ Error parsing lastSyncTime: $e");
      return DateTime.now().toUtc().subtract(const Duration(days: 1));
    }
  }

  Future<String?> getFilePathById(int id) async {
    final doc = await (db.select(db.documentTable)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();

    return doc?.fileUrl;
  }
}
