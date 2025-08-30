import 'package:care_sync/src/models/user/userSummary.dart';

import '../enums/careGiverPermission.dart';
import '../enums/userRole.dart';

class CareGiverAssignment {
  final int id;
  final UserSummary caregiver;
  final UserSummary patient;
  final CareGiverPermission permission;

  CareGiverAssignment({
    required this.id,
    required this.caregiver,
    required this.patient,
    required this.permission,
  });

  factory CareGiverAssignment.fromJson(Map<String, dynamic> json) {
    return CareGiverAssignment(
      id: json['id'],
      caregiver: UserSummary.fromJson(json['caregiver']),
      patient: UserSummary.fromJson(json['patient']),
      permission: CareGiverPermission.values.firstWhere(
        (e) => e.name == json['permission'],
      ),
    );
  }
}

final dummyCareGiverAssignments = [
  CareGiverAssignment(
    id: 1,
    caregiver: UserSummary(
      id: 10,
      email: "caregiver1@example.com",
      name: "Alice Johnson",
      role: UserRole.CAREGIVER,
    ),
    patient: UserSummary(
      id: 20,
      email: "patient1@example.com",
      name: "Bob Williams",
      role: UserRole.PATIENT,
    ),
    permission: CareGiverPermission.FULL_ACCESS,
  ),
  CareGiverAssignment(
    id: 2,
    caregiver: UserSummary(
      id: 11,
      email: "caregiver2@example.com",
      name: "Charlie Brown",
      role: UserRole.CAREGIVER,
    ),
    patient: UserSummary(
      id: 21,
      email: "patient2@example.com",
      name: "David Smith",
      role: UserRole.PATIENT,
    ),
    permission: CareGiverPermission.VIEW_ONLY,
  ),
  CareGiverAssignment(
    id: 3,
    caregiver: UserSummary(
      id: 12,
      email: "caregiver3@example.com",
      name: "Evelyn Clark",
      role: UserRole.CAREGIVER,
    ),
    patient: UserSummary(
      id: 22,
      email: "patient3@example.com",
      name: "Fiona Davis",
      role: UserRole.PATIENT,
    ),
    permission: CareGiverPermission.VIEW_ONLY,
  ),
];
