// ignore_for_file: constant_identifier_names

enum DocumentType {
  PRESCRIPTION,
  MEDICAL_REPORT,
  LAB_REPORT,
  DISCHARGE_SUMMARY,
  REFERRAL_LETTER,
  TEST_RESULT,
  OTHER;

  /// Convert enum to string for API requests
  String toJson() => name;

  /// Parse string from API response to enum
  static DocumentType fromJson(String value) => DocumentType.values.firstWhere(
        (e) => e.name == value,
        orElse: () => DocumentType.OTHER,
      );
}
