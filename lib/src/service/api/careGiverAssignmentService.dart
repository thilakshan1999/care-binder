import 'package:http/http.dart';

import '../../models/apiResponse.dart';
import '../../models/user/careGiverAssignment.dart';
import 'apiHelper.dart';

class CareGiverAssignmentService {
  final String baseUrl;
  final Client client;

  CareGiverAssignmentService({
    required this.baseUrl,
    required this.client,
  });

  /// GET /api/assignments/patient/caregivers
  Future<ApiResponse<List<CareGiverAssignment>>> getCaregiversOfPatient() {
    return ApiHelper.handleRequest<List<CareGiverAssignment>>(() async {
      final uri = Uri.parse('$baseUrl/assignments/patient/caregivers');
      final response = await client.get(uri);

      return response;
    }, (data) {
      final List<dynamic> list = data as List<dynamic>;
      return list.map((e) => CareGiverAssignment.fromJson(e)).toList();
    });
  }

  /// GET /api/assignments/caregiver/patients
  Future<ApiResponse<List<CareGiverAssignment>>> getPatientsOfCaregiver() {
    return ApiHelper.handleRequest<List<CareGiverAssignment>>(() async {
      final uri = Uri.parse('$baseUrl/assignments/caregiver/patients');
      final response = await client.get(uri);

      return response;
    }, (data) {
      final List<dynamic> list = data as List<dynamic>;
      return list.map((e) => CareGiverAssignment.fromJson(e)).toList();
    });
  }

  /// DELETE /api/assignments/{assignmentId}
  Future<ApiResponse<void>> removeAssignment(int assignmentId) {
    return ApiHelper.handleRequest<void>(() async {
      final uri = Uri.parse('$baseUrl/assignments/$assignmentId');
      final response = await client.delete(uri);
      return response;
    }, (_) {});
  }

  /// PUT /api/assignments/{assignmentId}/permission?permission=FULL_ACCESS
  Future<ApiResponse<void>> updatePermission(
      int assignmentId, String permission) {
    return ApiHelper.handleRequest<void>(() async {
      final uri = Uri.parse(
          '$baseUrl/assignments/$assignmentId/permission?permission=$permission');
      final response = await client.put(uri);
      return response;
    }, (_) {});
  }
}
