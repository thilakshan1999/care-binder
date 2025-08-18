import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:care_sync/src/models/apiResponse.dart';
import 'package:http/http.dart';

class ApiHelper {
  static Future<ApiResponse<T>> handleRequest<T>(
    Future<Response> Function() requestFn,
    T Function(dynamic) fromJson,
  ) async {
    try {
      final response = await requestFn().timeout(const Duration(seconds: 30));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonMap = jsonDecode(response.body);
        return ApiResponse<T>.fromJson(jsonMap, fromJson);
      } else {
        final jsonMap = jsonDecode(response.body);
        return ApiResponse<T>(
          success: false,
          message: 'Server error: ${jsonMap["message"]}',
          errorTittle: "Server Error",
          data: null,
        );
      }
    } on SocketException {
      return ApiResponse<T>(
        success: false,
        message: 'Network issue. Please check your connection.',
        errorTittle: "Network Issue",
        data: null,
      );
    } on TimeoutException {
      return ApiResponse<T>(
        success: false,
        message: 'The request timed out. Please try again later.',
        errorTittle: "Timeout",
        data: null,
      );
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Unexpected error occurred: $e',
        errorTittle: "Unexpected Error",
        data: null,
      );
    }
  }
}
