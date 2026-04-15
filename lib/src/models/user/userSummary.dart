import 'package:care_sync/src/models/enums/userRole.dart';

class UserSummary {
  final int id;
  final String email;
  final String? systemEmail;
  final String name;
  final UserRole role;

  UserSummary({
    required this.id,
    required this.email,
    this.systemEmail,
    required this.name,
    required this.role,
  });

  factory UserSummary.fromJson(Map<String, dynamic> json) {
    return UserSummary(
      id: json['id'],
      email: json['email'],
      systemEmail: json['systemEmail'],
      name: json['name'],
      role: UserRole.fromJson(json['role']),
    );
  }
}
