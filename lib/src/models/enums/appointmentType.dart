// ignore_for_file: constant_identifier_names

enum AppointmentType {
  CONSULTATION,
  FOLLOW_UP,
  SURGERY,
  DIAGNOSIS,
  CHECKUP,
  EMERGENCY,
  OTHER;

  /// Convert enum to string for API requests
  String toJson() => name;

  /// Parse string from API response to enum
  static AppointmentType fromJson(String value) =>
      AppointmentType.values.firstWhere(
        (e) => e.name == value,
        orElse: () => AppointmentType.OTHER,
      );
}
