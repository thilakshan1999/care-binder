import 'dart:convert';
import 'dart:io';

import 'package:care_sync/src/models/document/analyzedDocument.dart';
import 'package:care_sync/src/models/apiResponse.dart';
import 'package:care_sync/src/models/document/document.dart';
import 'package:care_sync/src/models/document/documentReference.dart';
import 'package:care_sync/src/models/document/documentSummary.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

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

  /// GET /api/documents/{id}/ref
  Future<ApiResponse<DocumentReference>> getDocumentRefById(int id) {
    return ApiHelper.handleRequest<DocumentReference>(() async {
      var uri = Uri.parse('$baseUrl/documents/$id/ref');
      var response = await client.get(uri);
      return response;
    }, (data) => DocumentReference.fromJson(data));
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
  Future<ApiResponse<void>> saveDocument(
    AnalyzedDocument dto,
    int? patientId,
    File file,
    String token,
  ) {
    return ApiHelper.handleRequest<void>(() async {
      var queryParams = <String, String>{};

      if (patientId != null) {
        queryParams['patientId'] = patientId.toString();
      }
      var uri = Uri.parse('$baseUrl/documents/save')
          .replace(queryParameters: queryParams);

      var request = MultipartRequest('POST', uri);
      request.files.add(MultipartFile.fromString(
        'dto',
        jsonEncode(dto.toJson()),
        contentType: MediaType('application', 'json'),
      ));

      request.files.add(
        await MultipartFile.fromPath(
          'file',
          file.path,
        ),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      var streamedResponse = await client.send(request);
      return await Response.fromStream(streamedResponse);
    }, (_) {});
  }
}
