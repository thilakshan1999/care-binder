import 'dart:convert';

import 'package:care_sync/src/database/app_database.dart';
import 'package:care_sync/src/models/appointment/appointment.dart';
import 'package:care_sync/src/models/doctor/doctor.dart';
import 'package:care_sync/src/models/document/document.dart';
import 'package:care_sync/src/models/document/documentDto.dart';
import 'package:care_sync/src/models/document/documentReference.dart';
import 'package:care_sync/src/models/document/documentSummary.dart';
import 'package:care_sync/src/models/enums/documentType.dart';
import 'package:care_sync/src/models/medicine/med.dart';
import 'package:care_sync/src/models/vital/vital.dart';
import 'package:care_sync/src/utils/textFormatUtils.dart';
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

  Future<void> saveSingleDocument(DocumentDto doc) async {
    await db.into(db.documentTable).insert(
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

  Future<void> deleteDocumentsByIds(List<int> ids) async {
    if (ids.isEmpty) return;

    await (db.delete(db.documentTable)..where((tbl) => tbl.id.isIn(ids))).go();
  }

  Future<List<DocumentSummary>> getDocumentsByUser(
    int userId,
    String? type,
    String? filterBy,
    String? sortOrder,
  ) async {
    final query = db.select(db.documentTable)
      ..where((tbl) => tbl.userId.equals(userId) & tbl.isDeleted.equals(false));

    if (type != null && type != "All") {
      query.where((tbl) =>
          tbl.documentType.equals(TextFormatUtils.reverseFormatName(type)));
    }

    query.orderBy([
      (tbl) => OrderingTerm(
            expression: (filterBy == "UPLOAD_TIME")
                ? tbl.updatedTime
                : (filterBy == "VISIT_TIME")
                    ? tbl.dateOfVisit
                    : tbl.dateOfTest,
            mode: (sortOrder == "DESCENDING")
                ? OrderingMode.desc
                : OrderingMode.asc,
          ),
    ]);

    final rows = await query.get();

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

  Future<Document?> getDocumentById(int id) async {
    final row = await (db.select(db.documentTable)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();

    if (row == null) return null;

    return Document(
      id: row.id,
      documentName: row.documentName,
      documentType: DocumentType.values.firstWhere(
        (e) => e.name == row.documentType,
      ),
      summary: row.summary ?? '',
      fileUrl: row.fileUrl,
      doctors: _parseDoctors(row.doctorsJson),
      vitals: _parseVitals(row.vitalsJson),
      medicines: _parseMedicines(row.medicinesJson),
      appointments: _parseAppointments(row.appointmentsJson),
      updatedTime: row.updatedTime,
      dateOfTest: row.dateOfTest,
      dateOfVisit: row.dateOfVisit,
    );
  }

  List<Doctor> _parseDoctors(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return [];

    final List data = jsonDecode(jsonStr);
    return data.map((e) => Doctor.fromJson(e)).toList();
  }

  List<Vital> _parseVitals(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return [];

    final List data = jsonDecode(jsonStr);
    return data.map((e) => Vital.fromJson(e)).toList();
  }

  List<Med> _parseMedicines(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return [];

    final List data = jsonDecode(jsonStr);
    return data.map((e) => Med.fromJson(e)).toList();
  }

  List<Appointment> _parseAppointments(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return [];

    final List data = jsonDecode(jsonStr);
    return data.map((e) => Appointment.fromJson(e)).toList();
  }

  Future<void> saveLastSyncTime(String email, String serverTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("lastSyncTime_$email", serverTime);

    print("✅ Saved last sync time for user $email: $serverTime");
  }

  Future<DateTime?> getLastSyncTime(String email) async {
    final prefs = await SharedPreferences.getInstance();

    final timeString = prefs.getString("lastSyncTime_$email");

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

  Future<DocumentReference?> getDocumentReferenceById(int id) async {
    final row = await (db.select(db.documentTable)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();

    if (row == null) return null;

    return DocumentReference(
      id: row.id,
      fileName: row.fileName ?? '',
      fileType: row.fileType ?? '',
      signedUrl: row.fileUrl ?? '',
    );
  }

  Future<List<DocumentReference>> getDocumentReferencesByIds(
      List<int> ids) async {
    if (ids.isEmpty) return [];

    final rows = await (db.select(db.documentTable)
          ..where((tbl) => tbl.id.isIn(ids)))
        .get();

    return rows
        .where((row) => row.fileUrl != null && row.fileUrl!.isNotEmpty)
        .map((row) => DocumentReference(
              id: row.id,
              fileName: row.fileName ?? '',
              fileType: row.fileType ?? '',
              signedUrl: row.fileUrl!,
            ))
        .toList();
  }
}
