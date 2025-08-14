import 'doctor.dart';
import 'enums/appointmentType.dart';
import 'enums/entityStatus.dart';

class AppointmentWithStatus {
  final int? id;
  String name;
  AppointmentType type;
  Doctor? doctor;
  DateTime appointmentDateTime;
  EntityStatus entityStatus;

  AppointmentWithStatus({
    this.id,
    required this.name,
    required this.type,
    this.doctor,
    required this.appointmentDateTime,
    required this.entityStatus,
  });

  factory AppointmentWithStatus.fromJson(Map<String, dynamic> json) {
    return AppointmentWithStatus(
      id: json['id'],
      name: json['name'],
      type: AppointmentType.fromJson(json['type']),
      doctor: json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null,
      appointmentDateTime: DateTime.parse(json['appointmentDateTime']),
      entityStatus: EntityStatus.fromJson(json['entityStatus'] ?? 'SAME'),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.toJson(),
        'doctor': doctor?.toJson(),
        'appointmentDateTime': appointmentDateTime.toIso8601String(),
        'entityStatus': entityStatus.toJson(),
      };

  AppointmentWithStatus copyWith({
    int? id,
    String? name,
    AppointmentType? type,
    Doctor? doctor,
    DateTime? appointmentDateTime,
    EntityStatus? entityStatus,
  }) {
    return AppointmentWithStatus(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      doctor: doctor ?? this.doctor,
      appointmentDateTime: appointmentDateTime ?? this.appointmentDateTime,
      entityStatus: entityStatus ?? this.entityStatus,
    );
  }
}
