import 'enums/entityStatus.dart';

class VitalWithStatus {
  final int? id;
  final String name;
  final String? unit;
  final Duration?
      remindDuration; // store as ISO8601 or seconds in JSON? Adapt as needed
  final DateTime? startDateTime;
  final EntityStatus entityStatus;

  VitalWithStatus({
    this.id,
    required this.name,
    this.unit,
    this.remindDuration,
    this.startDateTime,
    required this.entityStatus,
  });

  factory VitalWithStatus.fromJson(Map<String, dynamic> json) {
    return VitalWithStatus(
      id: json['id'],
      name: json['name'],
      unit: json['unit'],
      remindDuration: json['remindDuration'] != null
          ? Duration(seconds: json['remindDuration'])
          : null,
      startDateTime: json['startDateTime'] != null
          ? DateTime.parse(json['startDateTime'])
          : null,
      entityStatus: EntityStatus.fromJson(json['entityStatus'] ?? 'SAME'),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'unit': unit,
        'remindDuration': remindDuration?.inSeconds,
        'startDateTime': startDateTime?.toIso8601String(),
        'entityStatus': entityStatus.toJson(),
      };
}
