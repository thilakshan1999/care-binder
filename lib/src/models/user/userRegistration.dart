import 'package:care_sync/src/models/enums/userRole.dart';

class UserRegistration {
  UserRole? role;
  String? name;
  String? email;
  String? password;
  DateTime? dateOfBirth;

  UserRegistration({
    this.role,
    this.name,
    this.email,
    this.dateOfBirth,
    this.password,
  });

  UserRegistration copyWith({
    UserRole? role,
    String? name,
    String? email,
    String? password,
    DateTime? dateOfBirth,
  }) {
    return UserRegistration(
      role: role ?? this.role,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'role': role?.name,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
      };
}
