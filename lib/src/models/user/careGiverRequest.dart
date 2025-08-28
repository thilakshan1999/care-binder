import 'package:care_sync/src/models/user/userSummary.dart';

class CareGiverRequest {
  final int id;
  final UserSummary fromUser;
  final UserSummary toUser;
  final DateTime requestedAt;

  CareGiverRequest({
    required this.id,
    required this.fromUser,
    required this.toUser,
    required this.requestedAt,
  });

  factory CareGiverRequest.fromJson(Map<String, dynamic> json) {
    return CareGiverRequest(
      id: json['id'],
      fromUser: UserSummary.fromJson(json['fromUser']),
      toUser: UserSummary.fromJson(json['toUser']),
      requestedAt: DateTime.parse(json['requestedAt']),
    );
  }
}
