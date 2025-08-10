import 'doctor.dart';
import 'enums/AppointmentType.dart';
import 'enums/entityStatus.dart';

class AppointmentWithStatus {
  final int? id;
  final String name;
  final AppointmentType type;
  final Doctor doctor;
  final DateTime appointmentDateTime;
  final EntityStatus entityStatus;

  AppointmentWithStatus({
    this.id,
    required this.name,
    required this.type,
    required this.doctor,
    required this.appointmentDateTime,
    required this.entityStatus,
  });

  factory AppointmentWithStatus.fromJson(Map<String, dynamic> json) {
    return AppointmentWithStatus(
      id: json['id'],
      name: json['name'],
      type: AppointmentType.fromJson(json['type']),
      doctor: Doctor.fromJson(json['doctor']),
      appointmentDateTime: DateTime.parse(json['appointmentDateTime']),
      entityStatus: EntityStatus.fromJson(json['entityStatus'] ?? 'SAME'),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.toJson(),
        'doctor': doctor.toJson(),
        'appointmentDateTime': appointmentDateTime.toIso8601String(),
        'entityStatus': entityStatus.toJson(),
      };
}
