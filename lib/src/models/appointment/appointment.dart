import '../doctor/doctor.dart';
import '../enums/appointmentType.dart';

class Appointment {
  final int id;
  final String name;
  final AppointmentType type;
  final Doctor? doctor;
  final DateTime appointmentDateTime;

  Appointment({
    required this.id,
    required this.name,
    required this.type,
    this.doctor,
    required this.appointmentDateTime,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        id: json['id'],
        name: json['name'],
        type: AppointmentType.fromJson(json['type']),
        doctor: json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null,
        appointmentDateTime: DateTime.parse(json['appointmentDateTime']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.toJson(),
        'doctor': doctor?.toJson(),
        'appointmentDateTime': appointmentDateTime.toIso8601String(),
      };
}
