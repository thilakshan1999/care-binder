import 'dart:io';
import 'package:care_sync/src/models/apiResponse.dart';
import 'package:care_sync/src/service/api/apiHelper.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

class VisionService {
  final String baseUrl;
  final Client _client;

  VisionService({
    required this.baseUrl,
    required Client client,
  }) : _client = client;

  Future<ApiResponse<String>> extractTextFromImage(File imageFile) async {
    String ext = path.extension(imageFile.path).toLowerCase();
    String mimeType;
    switch (ext) {
      case '.jpg':
      case '.jpeg':
        mimeType = 'image/jpeg';
        break;
      case '.png':
        mimeType = 'image/png';
        break;
      case '.gif':
        mimeType = 'image/gif';
        break;
      case '.bmp':
        mimeType = 'image/bmp';
        break;
      case '.webp':
        mimeType = 'image/webp';
        break;
      default:
        mimeType = 'application/octet-stream'; // fallback
    }

    final mimeParts = mimeType.split('/');

    return ApiHelper.handleRequest<String>(() async {
      var uri = Uri.parse('$baseUrl/vision/extract');
      var request = MultipartRequest('POST', uri);

      request.files.add(await MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType(mimeParts[0], mimeParts[1]),
      ));

      var streamedResponse = await _client.send(request);
      return await Response.fromStream(streamedResponse);
    }, (data) => data.toString());
  }

}
