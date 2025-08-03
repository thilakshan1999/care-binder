import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis/documentai/v1.dart' as doc_ai;
import 'package:googleapis_auth/auth_io.dart';

class DocumentAIService {
  static const _scopes = [doc_ai.DocumentApi.cloudPlatformScope];

  // Replace with your Google Cloud details
  static const _projectId = 'care-sync-467705';
  static const _location = 'us';
  static const _processorId = '6adda2a5acbf6f8d';

  /// Process document bytes with the given mimeType, returns extracted text.
  static Future<String> processDocument({
    required List<int> fileBytes,
    required String mimeType,
  }) async {
    try {
      // Load service account JSON from assets
      final serviceAccountJson =
          await rootBundle.loadString('service-account.json');
      final serviceAccount =
          ServiceAccountCredentials.fromJson(serviceAccountJson);

      // Create authenticated HTTP client
      final client = await clientViaServiceAccount(serviceAccount, _scopes);

      final api = doc_ai.DocumentApi(client);

      // Prepare the request body
      final base64Content = base64Encode(fileBytes);
      final request = doc_ai.GoogleCloudDocumentaiV1ProcessRequest(
        rawDocument: doc_ai.GoogleCloudDocumentaiV1RawDocument(
          content: base64Content,
          mimeType: mimeType,
        ),
      );

      // Construct resource name of the processor
      const name =
          'projects/$_projectId/locations/$_location/processors/$_processorId';

      // Call Document AI API
      final response =
          await api.projects.locations.processors.process(request, name);

      client.close();

      // Return extracted text
      return response.document?.text ?? 'No text found.';
    } catch (e) {
      throw Exception('Document AI error: $e');
    }
  }
}
