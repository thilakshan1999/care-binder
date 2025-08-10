// ignore_for_file: constant_identifier_names

enum MedForm {
  TABLET,
  CAPSULE,
  SYRUP,
  INJECTION,
  POWDER,
  DROPS,
  CREAM,
  GEL,
  SPRAY,
  OTHER;

  /// Convert enum to string for API requests
  String toJson() => name;

  /// Parse string from API response to enum
  static MedForm fromJson(String value) => MedForm.values.firstWhere(
        (e) => e.name == value,
        orElse: () => MedForm.OTHER,
      );
}
