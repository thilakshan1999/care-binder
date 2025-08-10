import 'package:care_sync/src/service/api/documetAIService.dart';
import 'package:care_sync/src/service/api/loggingInterceptor.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'visionService.dart';

class HttpService {
  final InterceptedClient httpClient;
  final String baseUrl;
  late final VisionService visionService;
  late final DocumentAiService documentAiService;

  HttpService()
      : baseUrl = "http://10.0.2.2:8080/api",
        httpClient =
            InterceptedClient.build(interceptors: [LoggingInterceptor()]) {
    visionService = VisionService(baseUrl: baseUrl, client: httpClient);
    documentAiService = DocumentAiService(baseUrl: baseUrl, client: httpClient);
  }
}

class ApiResponse<T> {
  final bool success;
  final String message;
  final String? errorTittle;
  final T? data;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errorTittle,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      errorTittle: null,
    );
  }
}
