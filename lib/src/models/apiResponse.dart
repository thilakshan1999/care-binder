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
