import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

class DocumentPickerService {
  static Future<DocumentData?> pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      withData: true,
    );

    if (result != null && result.files.single.path != null) {
      final fileBytes = result.files.single.bytes!;
      final ext = p.extension(result.files.single.name).toLowerCase();

      String? mimeType;

      switch (ext) {
        case '.pdf':
          mimeType = 'application/pdf';
          break;
        case '.txt':
          mimeType = 'text/plain';
          break;
        case '.doc':
          mimeType = 'application/msword';
          break;
        case '.docx':
          mimeType =
              'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
          break;
        default:
          return null; // Unsupported file type
      }

      return DocumentData(fileBytes: fileBytes, mimeType: mimeType);
    }
    return null;
  }
}

class DocumentData {
  final Uint8List fileBytes;
  final String mimeType;

  DocumentData({required this.fileBytes, required this.mimeType});
}
