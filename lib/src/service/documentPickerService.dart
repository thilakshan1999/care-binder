import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

class DocumentPickerService {
  // 🔹 Unified method to detect MIME type
  static String? _getMimeType(String ext) {
    switch (ext.toLowerCase()) {
      case '.pdf':
        return 'application/pdf';
      case '.txt':
        return 'text/plain';
      case '.doc':
        return 'application/msword';
      case '.docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      default:
        return null;
    }
  }

  // 🔹 Pick document manually
  static Future<DocumentData?> pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      withData: true,
    );

    final path = result?.files.single.path;
    if (path == null) return null;

    final file = File(path);
    final mimeType = _getMimeType(p.extension(path));
    if (mimeType == null) return null;

    return DocumentData(file: file, mimeType: mimeType);
  }

  // 🔹 Create DocumentData from shared file URL
  static Future<DocumentData?> getDocumentFromUrl(String fileUrl) async {
    try {
      final file = File(Uri.parse(fileUrl).path);
      if (!await file.exists()) {
        print('⚠️ File not found: $fileUrl');
        return null;
      }

      final mimeType = _getMimeType(p.extension(file.path));
      if (mimeType == null) {
        print('⚠️ Unsupported file type: ${p.extension(file.path)}');
        return null;
      }

      return DocumentData(file: file, mimeType: mimeType);
    } catch (e) {
      print('❌ Error reading shared file: $e');
      return null;
    }
  }
}

class DocumentData {
  final File file;
  final String mimeType;

  DocumentData({required this.file, required this.mimeType});
}
