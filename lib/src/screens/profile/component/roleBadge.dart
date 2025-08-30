import 'package:care_sync/src/component/badge/simpleBadge.dart';
import 'package:care_sync/src/models/enums/userRole.dart';
import 'package:care_sync/src/utils/iconAndColorUtils.dart';
import 'package:care_sync/src/utils/textFormatUtils.dart';
import 'package:flutter/material.dart';

class RoleBadge extends StatelessWidget {
  final UserRole role;

  const RoleBadge({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final roleColor = IconAndColorUtils.getRoleColor(role);
    return SimpleBadge(
      color: roleColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            IconAndColorUtils.getRoleIcon(role),
            size: 16,
            color: roleColor,
          ),
          const SizedBox(width: 6),
          Text(
            TextFormatUtils.formatEnum(role),
            style: TextStyle(
              color: roleColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
