import 'package:care_sync/src/models/enums/careGiverPermission.dart';
import 'package:care_sync/src/models/enums/userRole.dart';
import 'package:care_sync/src/models/user/userSummary.dart';

class CareGiverRequest {
  final int id;
  final UserSummary fromUser;
  final UserSummary toUser;
  final DateTime requestedAt;
  final CareGiverPermission requestedPermission;

  CareGiverRequest({
    required this.id,
    required this.fromUser,
    required this.toUser,
    required this.requestedAt,
    required this.requestedPermission,
  });

  factory CareGiverRequest.fromJson(Map<String, dynamic> json) {
    return CareGiverRequest(
      id: json['id'],
      fromUser: UserSummary.fromJson(json['fromUser']),
      toUser: UserSummary.fromJson(json['toUser']),
      requestedAt: DateTime.parse(json['requestedAt']),
      requestedPermission: CareGiverPermission.fromJson(json['permission']),
    );
  }
}

final dummyCareGiverRequests = [
  CareGiverRequest(
    id: 1,
    fromUser: UserSummary(
      id: 10,
      email: "caregiver1@example.com",
      name: "Alice Johnson",
      role: UserRole.CAREGIVER,
    ),
    toUser: UserSummary(
      id: 20,
      email: "patient1@example.com",
      name: "Bob Williams",
      role: UserRole.PATIENT,
    ),
    requestedAt: DateTime.now().subtract(const Duration(minutes: 45)),
    requestedPermission: CareGiverPermission.VIEW_ONLY,
  ),
  CareGiverRequest(
    id: 2,
    fromUser: UserSummary(
      id: 11,
      email: "caregiver2@example.com",
      name: "Charlie Brown",
      role: UserRole.CAREGIVER,
    ),
    toUser: UserSummary(
      id: 21,
      email: "patient2@example.com",
      name: "David Smith",
      role: UserRole.PATIENT,
    ),
    requestedAt: DateTime.now().subtract(const Duration(hours: 3)),
    requestedPermission: CareGiverPermission.VIEW_ONLY,
  ),
  CareGiverRequest(
    id: 3,
    fromUser: UserSummary(
      id: 12,
      email: "caregiver3@example.com",
      name: "Evelyn Clark",
      role: UserRole.CAREGIVER,
    ),
    toUser: UserSummary(
      id: 22,
      email: "patient3@example.com",
      name: "Fiona Davis",
      role: UserRole.PATIENT,
    ),
    requestedAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    requestedPermission: CareGiverPermission.VIEW_ONLY,
  ),
];
