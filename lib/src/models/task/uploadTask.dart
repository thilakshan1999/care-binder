class UploadTask {
  final int id;
  final String fileName;
  final String fileUrl;
  final String mimeType;
  final int patientId;
  final String createdBy;
  final String status;
  final String? errorMessage;

  UploadTask({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.mimeType,
    required this.patientId,
    required this.createdBy,
    required this.status,
    this.errorMessage,
  });

  factory UploadTask.fromJson(Map<String, dynamic> json) {
    return UploadTask(
      id: json['id'] ?? 0,
      fileName: json['fileName'] ?? '',
      fileUrl: json['fileUrl'] ?? '',
      mimeType: json['mimeType'] ?? '',
      patientId: json['patientId'],
      createdBy: json['createdBy'] ?? '',
      status: json['status'] ?? '',
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'mimeType': mimeType,
      'patientId': patientId,
      'createdBy': createdBy,
      'status': status,
      'errorMessage': errorMessage,
    };
  }
}

final sampleTask = UploadTask(
  id: 101,
  fileName: 'chest_xray_v4.png',
  fileUrl: 'https://storage.med-app.com/uploads/101/xray.png',
  mimeType: 'image/png',
  patientId: 5502,
  createdBy: 'Dr. Sarah Smith',
  status: 'completed',
  errorMessage: null, // No error for a successful task
);
