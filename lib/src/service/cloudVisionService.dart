import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudVisionService {
  static const String apiKey = 'AIzaSyDxjJRj7odJLB4jWq4bm5sl-CB306rC-2g';

  Future<String> analyzeImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      const url =
          'https://vision.googleapis.com/v1/images:annotate?key=$apiKey';

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
        final responseData = jsonDecode(response.body);
        return responseData['responses'][0]['fullTextAnnotation']?['text'] ??
            'No text found.';
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to analyze image: $e');
    }
  }
}
