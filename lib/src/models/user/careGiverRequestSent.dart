import 'package:care_sync/src/models/enums/careGiverPermission.dart';

class CareGiverRequestSend {
  String patientUserEmail;
  CareGiverPermission requestedPermission;

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
