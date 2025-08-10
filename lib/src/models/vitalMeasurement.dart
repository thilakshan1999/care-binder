class VitalMeasurement {
  final int? id;
  final DateTime dateTime;
  final String value;

  VitalMeasurement({
    this.id,
    required this.dateTime,
    required this.value,
  });

  factory VitalMeasurement.fromJson(Map<String, dynamic> json) =>
      VitalMeasurement(
        id: json['id'],
        dateTime: DateTime.parse(json['dateTime']),
        value: json['value'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'dateTime': dateTime.toIso8601String(),
        'value': value,
      };
}
