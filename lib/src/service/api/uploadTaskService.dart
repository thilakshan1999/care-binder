import 'package:care_sync/src/models/apiResponse.dart';
import 'package:care_sync/src/models/task/uploadTask.dart';
import 'package:care_sync/src/service/api/apiHelper.dart';
import 'package:http/http.dart';

class UploadTaskService {
  final String baseUrl;
  final Client client;

  UploadTaskService({
    required this.baseUrl,
    required this.client,
  });

  /// GET /api/upload-tasks/{id}
  Future<ApiResponse<UploadTask>> getTaskById(
    int id,
    int? patientId,
  ) async {
    return ApiHelper.handleRequest<UploadTask>(() async {
      var uri = Uri.parse('$baseUrl/upload-tasks/$id').replace(
          queryParameters:
              patientId != null ? {'patientId': '$patientId'} : null);

      var response = await client.get(uri);
      return response;
    }, (data) => UploadTask.fromJson(data));
  }

  /// GET /api/upload-tasks
  Future<ApiResponse<List<UploadTask>>> getUserTasks({int? patientId}) async {
    return ApiHelper.handleRequest<List<UploadTask>>(() async {
      var uri = Uri.parse('$baseUrl/upload-tasks').replace(
          queryParameters:
              patientId != null ? {'patientId': '$patientId'} : null);

      var response = await client.get(uri);
      return response;
    }, (data) => (data as List).map((e) => UploadTask.fromJson(e)).toList());
  }

  /// DELETE /api/upload-tasks/{id}
  Future<ApiResponse<void>> deleteTask({
    required int id,
    int? patientId,
  }) async {
    return ApiHelper.handleRequest<void>(() async {
      var uri = Uri.parse('$baseUrl/upload-tasks/$id').replace(
          queryParameters:
              patientId != null ? {'patientId': '$patientId'} : null);

      var response = await client.delete(uri);
      return response;
    }, (_) {});
  }

  /// GET /api/upload-tasks/{id}/retry
  Future<ApiResponse<void>> retryTask({
    required int id,
    int? patientId,
  }) async {
    return ApiHelper.handleRequest<void>(() async {
      var uri = Uri.parse('$baseUrl/upload-tasks/$id/retry').replace(
          queryParameters:
              patientId != null ? {'patientId': '$patientId'} : null);

      var response = await client.post(uri);
      return response;
    }, (_) {});
  }
}
