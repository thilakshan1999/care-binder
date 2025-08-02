import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CloudVisionService {
  final String _apiKey = dotenv.env['GOOGLE_CLOUD_VISION_API_KEY'] ?? '';

  Future<CloudVisionResponse> analyzeImage(File imageFile) async {
    if (_apiKey.isEmpty) {
      return CloudVisionResponse(
        success: false,
        errorTitle: 'API Key Missing',
        errorMessage: 'API key not found. Please check your .env file.',
      );
    }

    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final url =
          'https://vision.googleapis.com/v1/images:annotate?key=$_apiKey';

      final body = jsonEncode({
        "requests": [
          {
            "image": {"content": base64Image},
            "features": [
              {"type": "TEXT_DETECTION"}
            ]
          }
        ]
      });

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['responses'][0]['fullTextAnnotation']?['text'];
        return CloudVisionResponse(
          success: true,
          text: text ?? 'No text found.',
        );
      } else {
        final err = jsonDecode(response.body);
        final errorMessage = err['error']?['message'] ?? 'Unknown error';
        return CloudVisionResponse(
          success: false,
          errorTitle: 'API Error',
          errorMessage: errorMessage,
        );
      }
    } on SocketException {
      return CloudVisionResponse(
        success: false,
        errorTitle: 'Network Error',
        errorMessage: 'Please check your internet connection.',
      );
    } on FormatException {
      return CloudVisionResponse(
        success: false,
        errorTitle: 'Format Error',
        errorMessage: 'Invalid response format from the server.',
      );
    } catch (e) {
      return CloudVisionResponse(
        success: false,
        errorTitle: 'Unexpected Error',
        errorMessage: e.toString(),
      );
    }
  }
}

class CloudVisionResponse {
  final String? text;
  final bool success;

  final String? errorTitle;
  final String? errorMessage;

  CloudVisionResponse({
    this.text,
    required this.success,
    this.errorTitle,
    this.errorMessage,
  });
}
