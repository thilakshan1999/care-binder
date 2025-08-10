import 'dart:io';

import 'package:care_sync/src/models/apiResponse.dart';
import 'package:care_sync/src/service/api/apiHelper.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

class DocumentAiService {
  final String baseUrl;
  final Client client;

  DocumentAiService({
    required this.baseUrl,
    required this.client,
  });

  Future<ApiResponse<String>> extractTextFromDocument(
      File documentFile, String mimeType) async {
    final mimeParts = mimeType.split('/');

    return ApiHelper.handleRequest<String>(() async {
      var uri = Uri.parse('$baseUrl/document/extract');
      var request = MultipartRequest('POST', uri);

      request.files.add(await MultipartFile.fromPath(
        'file',
        documentFile.path,
        contentType: MediaType(mimeParts[0], mimeParts[1]),
      ));

      var streamedResponse = await client.send(request);
      return await Response.fromStream(streamedResponse);
    }, (data) => data.toString());
  }
}
