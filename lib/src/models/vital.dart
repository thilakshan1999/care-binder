import '../utils/durationFormatUtils.dart';
import 'vitalMeasurement.dart';

class Vital {
  final int id;
  final String name;
  final Duration? remindDuration;
  final DateTime? startDateTime;
  final String? unit;
  final List<VitalMeasurement> measurements;

  Vital({
    required this.id,
    required this.name,
    this.remindDuration,
    this.startDateTime,
    this.unit,
    required this.measurements,
  });

  factory Vital.fromJson(Map<String, dynamic> json) => Vital(
        id: json['id'],
        name: json['name'],
        remindDuration:
            DurationFormatUtils.parseIso8601Duration(json['remindDuration']),
        startDateTime: DateTime.parse(json['startDateTime']),
        unit: json['unit'],
        measurements: (json['measurements'] as List<dynamic>)
            .map((e) => VitalMeasurement.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'remindDuration':
            DurationFormatUtils.formatIso8601Duration(remindDuration),
        'startDateTime': startDateTime?.toIso8601String(),
        'unit': unit,
        'measurements': measurements.map((e) => e.toJson()).toList(),
      };
}
