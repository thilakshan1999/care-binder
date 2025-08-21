import '../../utils/durationFormatUtils.dart';
import '../enums/entityStatus.dart';
import 'vitalMeasurement.dart';

class VitalWithStatus {
  final int? id;
  String name;
  String? unit;
  Duration? remindDuration;
  DateTime? startDateTime;
  List<VitalMeasurement> measurements;
  EntityStatus entityStatus;

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

  VitalWithStatus copyWith({
    int? id,
    String? name,
    String? unit,
    bool unitSetNull = false,
    Duration? remindDuration,
    bool remindDurationSetNull = false,
    DateTime? startDateTime,
    bool startDateTimeSetNull = false,
    List<VitalMeasurement>? measurements,
    EntityStatus? entityStatus,
  }) {
    return VitalWithStatus(
      id: id ?? this.id,
      name: name ?? this.name,
      unit: unitSetNull ? null : (unit ?? this.unit),
      remindDuration: remindDurationSetNull
          ? null
          : (remindDuration ?? this.remindDuration),
      startDateTime:
          startDateTimeSetNull ? null : (startDateTime ?? this.startDateTime),
      measurements:
          measurements ?? List<VitalMeasurement>.from(this.measurements),
      entityStatus: entityStatus ?? this.entityStatus,
    );
  }
}
