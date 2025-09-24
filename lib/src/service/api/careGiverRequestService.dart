import 'dart:convert';

import 'package:care_sync/src/models/user/careGiverRequest.dart';
import 'package:care_sync/src/models/user/careGiverRequestSent.dart';
import 'package:http/http.dart';

import '../../models/apiResponse.dart';
import 'apiHelper.dart';

class CareGiverRequestService {
  final String baseUrl;
  final Client client;

  CareGiverRequestService({
    required this.baseUrl,
    required this.client,
  });

  /// POST /api/caregiver-requests/send
  Future<ApiResponse<void>> sendRequest(CareGiverRequestSend dto) {
    return ApiHelper.handleRequest<void>(() async {
      var uri = Uri.parse('$baseUrl/caregiver-requests/send');
      var response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dto.toJson()),
      );
      return response;
    }, (_) {});
  }

  /// GET /api/caregiver-requests/sent
  Future<ApiResponse<List<CareGiverRequest>>> getSentRequests() {
    return ApiHelper.handleRequest<List<CareGiverRequest>>(() async {
      var uri = Uri.parse('$baseUrl/caregiver-requests/sent');
      var response = await client.get(uri, headers: {
        'Content-Type': 'application/json',
      });
      return response;
    },
        (data) =>
            (data as List).map((e) => CareGiverRequest.fromJson(e)).toList());
  }

  /// GET /api/caregiver-requests/received
  Future<ApiResponse<List<CareGiverRequest>>> getReceivedRequests() {
    return ApiHelper.handleRequest<List<CareGiverRequest>>(() async {
      var uri = Uri.parse('$baseUrl/caregiver-requests/received');
      var response = await client.get(uri, headers: {
        'Content-Type': 'application/json',
      });
      return response;
    },
        (data) =>
            (data as List).map((e) => CareGiverRequest.fromJson(e)).toList());
  }

  /// POST /api/caregiver-requests/{requestId}/accept
  Future<ApiResponse<void>> acceptRequest(int requestId) {
    return ApiHelper.handleRequest<void>(() async {
      var uri = Uri.parse('$baseUrl/caregiver-requests/$requestId/accept');
      var response = await client.post(uri, headers: {
        'Content-Type': 'application/json',
      });
      return response;
    }, (_) {});
  }

  /// POST /api/caregiver-requests/{requestId}/reject
  Future<ApiResponse<void>> rejectRequest(int requestId) {
    return ApiHelper.handleRequest<void>(() async {
      var uri = Uri.parse('$baseUrl/caregiver-requests/$requestId/reject');
      var response = await client.post(uri, headers: {
        'Content-Type': 'application/json',
      });
      return response;
    }, (_) {});
  }

  /// POST /api/caregiver-requests/generate-qr
  Future<ApiResponse<String>> generateQrToken(String permission) {
    return ApiHelper.handleRequest<String>(() async {
      var uri = Uri.parse('$baseUrl/caregiver-requests/generate-qr');

      var response = await client.post(
        uri.replace(queryParameters: {
          'permission': permission, // VIEW_ONLY or FULL_ACCESS
        }),
        headers: {'Content-Type': 'application/json'},
      );

      return response;
    }, (data) => data as String);
  }

  /// POST /api/caregiver-requests/link-via-qr
  Future<ApiResponse<void>> linkViaQr(String qrToken) {
    return ApiHelper.handleRequest<void>(() async {
      var uri = Uri.parse('$baseUrl/caregiver-requests/link-via-qr');

      var response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'qrToken': qrToken}),
      );

      return response;
    }, (_) {});
  }
}
