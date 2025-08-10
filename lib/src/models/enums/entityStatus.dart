// ignore_for_file: constant_identifier_names

enum EntityStatus {
  NEW,
  UPDATED,
  SAME;

  String toJson() => name;

  static EntityStatus fromJson(String value) => EntityStatus.values.firstWhere(
        (e) => e.name == value,
        orElse: () => EntityStatus.SAME,
      );
}
