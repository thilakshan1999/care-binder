import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/models/interceptor_contract.dart';

class LoggingInterceptor extends InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({
    required BaseRequest request,
  }) async {
    debugPrint('----- Request -----');
    debugPrint('URI: ${request.url}');
    debugPrint('Method: ${request.method}');
    debugPrint('Headers: ${request.headers}');

    if (request is Request) {
      debugPrint('Body: ${request.body}');
    } else {
      debugPrint('Request body not logged for type: ${request.runtimeType}');
    }

    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    debugPrint('----- Response -----');
    debugPrint('Code: ${response.statusCode}');
    if (response is Response) {
      debugPrint((response).body);
    } else {
      debugPrint('Response body not logged for type: ${response.runtimeType}');
    }
    return response;
  }
}
