import '../utils/durationFormatUtils.dart';
import 'enums/entityStatus.dart';
import 'vitalMeasurement.dart';

class VitalWithStatus {
  final int? id;
  final String name;
  final String? unit;
  final Duration? remindDuration;
  final DateTime? startDateTime;
  final List<VitalMeasurement> measurements;
  final EntityStatus entityStatus;

  VitalWithStatus({
    this.id,
    required this.name,
    this.unit,
    this.remindDuration,
    this.startDateTime,
    required this.measurements,
    required this.entityStatus,
  });

  factory VitalWithStatus.fromJson(Map<String, dynamic> json) {
    return VitalWithStatus(
      id: json['id'],
      name: json['name'],
      unit: json['unit'],
      remindDuration:
          DurationFormatUtils.parseIso8601Duration(json['remindDuration']),
      startDateTime: json['startDateTime'] != null
          ? DateTime.parse(json['startDateTime'])
          : null,
      measurements: (json['measurements'] as List<dynamic>)
          .map((e) => VitalMeasurement.fromJson(e))
          .toList(),
      entityStatus: EntityStatus.fromJson(json['entityStatus']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'unit': unit,
        'remindDuration':
            DurationFormatUtils.formatIso8601Duration(remindDuration),
        'startDateTime': startDateTime?.toIso8601String(),
        'measurements': measurements.map((e) => e.toJson()).toList(),
        'entityStatus': entityStatus.toJson(),
      };
}
