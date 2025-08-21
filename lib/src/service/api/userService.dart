import 'dart:convert';

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

  /// POST /api/users/register
  // Future<ApiResponse<AuthResponseDto>> register(UserRegistrationDto dto) {
  //   return ApiHelper.handleRequest<AuthResponseDto>(() async {
  //     var uri = Uri.parse('$baseUrl/users/register');
  //     var response = await client.post(
  //       uri,
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(dto.toJson()),
  //     );
  //     return response;
  //   }, (data) => AuthResponseDto.fromJson(data));
  // }

  // /// POST /api/users/login
  // Future<ApiResponse<AuthResponseDto>> login(LoginRequestDto dto) {
  //   return ApiHelper.handleRequest<AuthResponseDto>(() async {
  //     var uri = Uri.parse('$baseUrl/users/login');
  //     var response = await client.post(
  //       uri,
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(dto.toJson()),
  //     );
  //     return response;
  //   }, (data) => AuthResponseDto.fromJson(data));
  // }

  // /// POST /api/users/refresh-token
  // Future<ApiResponse<AuthResponseDto>> refreshToken(String refreshToken) {
  //   return ApiHelper.handleRequest<AuthResponseDto>(() async {
  //     var uri = Uri.parse('$baseUrl/users/refresh-token');
  //     var response = await client.post(
  //       uri,
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({'refreshToken': refreshToken}),
  //     );
  //     return response;
  //   }, (data) => AuthResponseDto.fromJson(data));
  // }
}
