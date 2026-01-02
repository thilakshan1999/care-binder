class DocumentReference {
  final int id;
  final String fileName;
  final String fileType;
  final String signedUrl;

  DocumentReference({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.signedUrl,
  });

  factory DocumentReference.fromJson(Map<String, dynamic> json) {
    return DocumentReference(
      id: json['id'],
      fileName: json['fileName'],
      fileType: json['fileType'],
      signedUrl: json['signedUrl'],
    );
  }
}

final sampleDocumentRef = DocumentReference(
    id: 101,
    fileName: "blood_report_2025.pdf",
    fileType: "application/pdf",
    signedUrl:
        "https://storage.googleapis.com/care-sync-bucket/blood_report_2025.pdf?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=fake-credential&X-Goog-Date=20251230T100000Z&X-Goog-Expires=900&X-Goog-SignedHeaders=host&X-Goog-Signature=fake-signature");
