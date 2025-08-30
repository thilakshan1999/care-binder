import 'package:flutter/material.dart';

import '../models/enums/careGiverPermission.dart';
import '../models/enums/entityStatus.dart';
import '../models/enums/userRole.dart';

class IconAndColorUtils {
  static IconData getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.CAREGIVER:
        return Icons.volunteer_activism;
      case UserRole.PATIENT:
        return Icons.elderly;
      default:
        return Icons.person;
    }
  }

  static Color getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.CAREGIVER:
        return Colors.green;
      case UserRole.PATIENT:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  static Color getPermissionColor(CareGiverPermission permission) {
    switch (permission) {
      case CareGiverPermission.FULL_ACCESS:
        return Colors.green;
      case CareGiverPermission.VIEW_ONLY:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  static Color getStatusColor(EntityStatus status) {
    switch (status) {
      case EntityStatus.NEW:
        return Colors.green;
      case EntityStatus.UPDATED:
        return Colors.orange;
      case EntityStatus.SAME:
      default:
        return Colors.grey;
    }
  }
}
