import 'dart:convert';

import 'package:care_sync/src/models/document/analyzedDocument.dart';
import 'package:care_sync/src/models/apiResponse.dart';
import 'package:care_sync/src/models/document/document.dart';
import 'package:care_sync/src/models/document/documentSummary.dart';
import 'package:http/http.dart';

import 'apiHelper.dart';

class DocumentService {
  final String baseUrl;
  final Client client;

  DocumentService({
    required this.baseUrl,
    required this.client,
  });

  /// POST /api/documents/analyze
  Future<ApiResponse<AnalyzedDocument>> analyzeDocument(
      String prompt, int? patientId) {
    return ApiHelper.handleRequest<AnalyzedDocument>(() async {
      var queryParams = <String, String>{};

      if (patientId != null) {
        queryParams['patientId'] = patientId.toString();
      }

      var uri = Uri.parse('$baseUrl/documents/analyze')
          .replace(queryParameters: queryParams);
      var response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': prompt}),
      );
      return response;
    }, (data) => AnalyzedDocument.fromJson(data));
  }

  /// DELETE /api/documents/{id}
  Future<ApiResponse<void>> deleteDocument(int id) {
    return ApiHelper.handleRequest<void>(() async {
      var uri = Uri.parse('$baseUrl/documents/$id');
      var response = await client.delete(uri);
      return response;
    }, (_) {});
  }

  /// GET /api/documents/{id}
  Future<ApiResponse<Document>> getDocumentById(int id) {
    return ApiHelper.handleRequest<Document>(() async {
      var uri = Uri.parse('$baseUrl/documents/$id');
      var response = await client.get(uri);
      return response;
    }, (data) => Document.fromJson(data));
  }

  /// GET /api/documents
  Future<ApiResponse<List<DocumentSummary>>> getAllDocumentsSummary({
    String? type,
    int? patientId,
  }) {
    return ApiHelper.handleRequest<List<DocumentSummary>>(() async {
      var queryParams = <String, String>{};

      if (type != null && type.isNotEmpty) {
        queryParams['type'] = type;
      }
      if (patientId != null) {
        queryParams['patientId'] = patientId.toString();
      }

      var uri =
          Uri.parse('$baseUrl/documents').replace(queryParameters: queryParams);

      var response = await client.get(uri);
      return response;
    },
        (data) =>
            (data as List).map((e) => DocumentSummary.fromJson(e)).toList());
  }

  /// POST /api/documents
  Future<ApiResponse<void>> saveDocument(AnalyzedDocument dto, int? patientId) {
    return ApiHelper.handleRequest<void>(() async {
      var queryParams = <String, String>{};

      if (patientId != null) {
        queryParams['patientId'] = patientId.toString();
      }
      var uri =
          Uri.parse('$baseUrl/documents').replace(queryParameters: queryParams);
      var response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dto.toJson()),
      );
      return response;
    }, (_) {});
  }
}
