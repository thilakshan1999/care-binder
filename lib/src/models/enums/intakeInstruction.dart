// ignore_for_file: constant_identifier_names

enum IntakeInstruction {
  BEFORE_EAT,
  AFTER_EAT,
  WHILE_EAT,
  DOES_NOT_MATTER;

  /// Convert enum to string for API requests
  String toJson() => name;

  /// Parse string from API response to enum
  static IntakeInstruction fromJson(String value) =>
      IntakeInstruction.values.firstWhere(
        (e) => e.name == value,
        orElse: () => IntakeInstruction.DOES_NOT_MATTER,
      );
}
