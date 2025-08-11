import 'package:care_sync/src/service/api/documentService.dart';
import 'package:care_sync/src/service/api/documetAIService.dart';
import 'package:care_sync/src/service/api/loggingInterceptor.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'visionService.dart';

class HttpService {
  final InterceptedClient httpClient;
  final String baseUrl;
  late final VisionService visionService;
  late final DocumentAiService documentAiService;
  late final DocumentService documentService;

  HttpService()
      : baseUrl = "http://10.0.2.2:8080/api",
        httpClient =
            InterceptedClient.build(interceptors: [LoggingInterceptor()]) {
    visionService = VisionService(baseUrl: baseUrl, client: httpClient);
    documentAiService = DocumentAiService(baseUrl: baseUrl, client: httpClient);
    documentService = DocumentService(baseUrl: baseUrl, client: httpClient);
  }
}
