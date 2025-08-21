import '../enums/entityStatus.dart';

class DoctorWithStatus {
  final int? id;
  String name;
  String? specialization;
  String? phoneNumber;
  String? email;
  String? address;
  EntityStatus entityStatus;

  DoctorWithStatus({
    this.id,
    required this.name,
    this.specialization,
    this.phoneNumber,
    this.email,
    this.address,
    required this.entityStatus,
  });

  factory DoctorWithStatus.fromJson(Map<String, dynamic> json) {
    return DoctorWithStatus(
      id: json['id'],
      name: json['name'],
      specialization: json['specialization'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      address: json['address'],
      entityStatus: EntityStatus.fromJson(json['entityStatus']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'specialization': specialization,
        'phoneNumber': phoneNumber,
        'email': email,
        'address': address,
        'entityStatus': entityStatus.toJson(),
      };

  DoctorWithStatus copyWith({
    int? id,
    String? name,
    String? specialization,
    String? phoneNumber,
    String? email,
    String? address,
    EntityStatus? entityStatus,
  }) {
    return DoctorWithStatus(
      id: id ?? this.id,
      name: name ?? this.name,
      specialization: specialization ?? this.specialization,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      entityStatus: entityStatus ?? this.entityStatus,
    );
  }
}
