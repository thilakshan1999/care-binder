import 'package:flutter/material.dart';

import '../../../component/badge/simpleBadge.dart';
import '../../../component/text/bodyText.dart';
import '../../../component/text/btnText.dart';
import '../../../component/text/primaryText.dart';
import '../../../models/enums/userRole.dart';
import '../../../models/user/careGiverAssignment.dart';
import '../../../models/user/userSummary.dart';
import '../../../utils/iconAndColorUtils.dart';
import '../../../utils/textFormatUtils.dart';

class CareRelationshipCard extends StatelessWidget {
  final CareGiverAssignment member;
  final UserRole role;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  const CareRelationshipCard({
    super.key,
    required this.member,
    required this.role,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    UserSummary userSummary =
        role == UserRole.CAREGIVER ? member.patient : member.caregiver;
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              IconAndColorUtils.getRoleIcon(userSummary.role),
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(text: userSummary.name),
                const SizedBox(height: 4),
                BodyText(
                  text: userSummary.email,
                ),
                const SizedBox(height: 4),
                SimpleBadge(
                  color:
                      IconAndColorUtils.getPermissionColor(member.permission),
                  child: Text(
                    TextFormatUtils.formatEnum(member.permission),
                    style: TextStyle(
                      color: IconAndColorUtils.getPermissionColor(
                          member.permission),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'update') {
                  onUpdate();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (BuildContext context) => [
                if (role == UserRole.PATIENT)
                  PopupMenuItem(
                    value: 'update',
                    child: Row(
                      children: [
                        Icon(Icons.admin_panel_settings,
                            size: 20,
                            color: Theme.of(context).colorScheme.onSecondary),
                        BtnText(
                          text: "Access",
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontWeight: FontWeight.w400,
                        )
                      ],
                    ),
                  ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete,
                          size: 20, color: Theme.of(context).colorScheme.error),
                      BtnText(
                        text: "Delete",
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w400,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
