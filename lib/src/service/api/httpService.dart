import 'package:care_sync/src/service/api/documentService.dart';
import 'package:care_sync/src/service/api/documetAIService.dart';
import 'package:care_sync/src/service/api/loggingInterceptor.dart';
import 'package:care_sync/src/service/api/userService.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import '../../bloc/userBloc.dart';
import 'authInterceptor.dart';
import 'visionService.dart';

// class HttpService {
//   final InterceptedClient httpClient;
//   final String baseUrl;
//   late final VisionService visionService;
//   late final DocumentAiService documentAiService;
//   late final DocumentService documentService;
//   late final UserService userService;

//   HttpService()
//       : baseUrl = "http://10.0.2.2:8080/api",
//         httpClient =
//             InterceptedClient.build(interceptors: [LoggingInterceptor()]) {
//     visionService = VisionService(baseUrl: baseUrl, client: httpClient);
//     documentAiService = DocumentAiService(baseUrl: baseUrl, client: httpClient);
//     documentService = DocumentService(baseUrl: baseUrl, client: httpClient);
//     userService = UserService(baseUrl: baseUrl, client: httpClient);
//   }
// }
class HttpService {
  late final InterceptedClient httpClient;
  final String baseUrl;

  late final VisionService visionService;
  late final DocumentAiService documentAiService;
  late final DocumentService documentService;
  late final UserService userService;

  HttpService(UserBloc userBloc)
      : baseUrl = "http://10.0.2.2:8080/api" {
    httpClient = InterceptedClient.build(
      interceptors: [
        LoggingInterceptor(),
        AuthInterceptor(userBloc, this),
      ],
    );

    visionService = VisionService(baseUrl: baseUrl, client: httpClient);
    documentAiService = DocumentAiService(baseUrl: baseUrl, client: httpClient);
    documentService = DocumentService(baseUrl: baseUrl, client: httpClient);
    userService = UserService(baseUrl: baseUrl, client: httpClient);
  }
}