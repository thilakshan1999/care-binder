import 'dart:io';

import 'package:care_sync/src/database/repository/document_repository.dart';
import 'package:care_sync/src/models/document/documentDto.dart';
import 'package:care_sync/src/service/api/httpService.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class SyncService {
  final DocumentRepository documentRepo;
  final HttpService httpService;
  final String email;

  SyncService({
    required this.documentRepo,
    required this.httpService,
    required this.email,
  });

  Future<void> syncDocuments() async {
    try {
      final lastSyncTime = await documentRepo.getLastSyncTime(email);

      if (lastSyncTime == null) {
        print("⚠️ Last sync time is null. Using fallback.");
        return;
      }

      print("last sync time : ----------------");
      print(lastSyncTime);

      final formatted = lastSyncTime
          .toIso8601String()
          .split('.')
          .first; // remove microseconds

      final response = await httpService.documentService
          .syncDocuments(lastSyncTime: formatted);

      if (response.data == null) {
        print("⚠️ Sync response data is null");
        return;
      }

      final syncData = response.data!;
      await _processUpdatedDocuments(syncData.updatedDocuments);
      await _processDeletedDocuments(syncData.deletedDocumentIds);
      await _updateSyncTime(syncData.serverTime);

      print("✅ Sync completed");
    } catch (e) {
      print("❌ Sync failed: $e");
    }
  }

  Future<void> _processUpdatedDocuments(List<DocumentDto> docs) async {
    if (docs.isEmpty) {
      print("ℹ️ No updated documents");
      return;
    }

    for (final doc in docs) {
      try {
        await _handleSingleDocument(doc);

        await documentRepo.saveSingleDocument(doc);

        String timeToSave = doc.updatedTime.toIso8601String().split('.').first;
        await documentRepo.saveLastSyncTime(email, timeToSave);

        print("💾 Progress saved for doc: ${doc.id}");
      } catch (e) {
        print("⚠️ Failed to process doc ${doc.id}: $e");
        continue;
      }
    }

    await documentRepo.saveDocuments(docs);
  }

  Future<void> _handleSingleDocument(DocumentDto doc) async {
    if (doc.fileUrl == null || doc.fileUrl!.isEmpty) return;

    // 🔹 Get old file
    final oldPath = await documentRepo.getFilePathById(doc.id);

    // 🔹 Download new file
    final localPath = await downloadAndSaveFile(
      doc.fileUrl!,
      doc.fileName ?? "doc_${doc.id}",
    );

    if (localPath != null) {
      doc.fileUrl = localPath;

      // 🔹 Delete old file
      await _deleteOldFile(oldPath);
    }
  }

  Future<void> _deleteOldFile(String? path) async {
    if (path == null || path.isEmpty) return;

    final file = File(path);
    if (await file.exists()) {
      await file.delete();
      print("🗑️ Old file deleted: $path");
    }
  }

  Future<void> _processDeletedDocuments(List<int> ids) async {
    if (ids.isEmpty) {
      print("ℹ️ No deleted documents");
      return;
    }

    await documentRepo.deleteDocumentsByIds(ids);
  }

  Future<void> _updateSyncTime(String? serverTime) async {
    if (serverTime == null || serverTime.isEmpty) {
      print("⚠️ Server time missing");
      return;
    }

    print("serverTime: $serverTime");
    await documentRepo.saveLastSyncTime(email, serverTime);
  }

  Future<String?> downloadAndSaveFile(String url, String fileName) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        print("❌ Failed to download file");
        return null;
      }

      final dir = await getApplicationDocumentsDirectory();
      final filePath = p.join(dir.path, fileName);

      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      print("✅ File saved: $filePath");

      return filePath;
    } catch (e) {
      print("❌ File download error: $e");
      return null;
    }
  }
}
