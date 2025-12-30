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
