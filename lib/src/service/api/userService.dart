import 'dart:convert';

import 'package:care_sync/src/models/user/authResponse.dart';
import 'package:care_sync/src/models/user/loginRequest.dart';
import 'package:care_sync/src/models/user/userRegistration.dart';
import 'package:http/http.dart';

import '../../models/apiResponse.dart';
import 'apiHelper.dart';

class UserService {
  final String baseUrl;
  final Client client;

  UserService({
    required this.baseUrl,
    required this.client,
  });

  /// GET /api/users/check-email
  Future<ApiResponse<bool>> checkEmail(String email) {
    return ApiHelper.handleRequest<bool>(() async {
      var uri = Uri.parse('$baseUrl/users/check-email?email=$email');
      var response = await client.get(uri, headers: {
        'Content-Type': 'application/json',
      });
      return response;
    }, (data) => data as bool);
  }

  // / POST /api/users/register
  Future<ApiResponse<AuthResponse>> register(UserRegistration user) {
    return ApiHelper.handleRequest<AuthResponse>(() async {
      var uri = Uri.parse('$baseUrl/users/register');
      var response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );
      return response;
    }, (data) => AuthResponse.fromJson(data));
  }

  /// POST /api/users/login
  Future<ApiResponse<AuthResponse>> login(LoginRequest request) {
    return ApiHelper.handleRequest<AuthResponse>(() async {
      var uri = Uri.parse('$baseUrl/users/login');
      var response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
      return response;
    }, (data) => AuthResponse.fromJson(data));
  }

  /// POST /api/users/refresh-token
  Future<ApiResponse<AuthResponse>> refreshToken(String refreshToken) {
    return ApiHelper.handleRequest<AuthResponse>(() async {
      var uri = Uri.parse('$baseUrl/users/refresh-token');
      var response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );
      return response;
    }, (data) => AuthResponse.fromJson(data));
  }
}
