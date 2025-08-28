// ignore_for_file: constant_identifier_names

enum CareGiverPermission {
  VIEW_ONLY,
  FULL_ACCESS;

  /// Convert enum to string for API requests
  String toJson() => name;

  /// Parse string from API response to enum
  static CareGiverPermission fromJson(String value) =>
      CareGiverPermission.values.firstWhere(
        (e) => e.name == value,
        orElse: () => CareGiverPermission.VIEW_ONLY,
      );
}
