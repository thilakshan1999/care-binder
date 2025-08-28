import 'package:care_sync/src/models/enums/careGiverPermission.dart';

class CareGiverRequestSend {
  final String patientUserEmail;
  final CareGiverPermission requestedPermission;

  CareGiverRequestSend({
    required this.patientUserEmail,
    required this.requestedPermission,
  });

  Map<String, dynamic> toJson() {
    return {
      'patientUserEmail': patientUserEmail,
      'requestedPermission': requestedPermission.toJson(),
    };
  }
}
