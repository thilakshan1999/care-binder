import 'package:care_sync/src/component/snakbar/customSnakbar.dart';
import 'package:care_sync/src/component/text/subText.dart';
import 'package:care_sync/src/service/connectivityService.dart';
import 'package:care_sync/src/theme/customColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                if (userSummary.systemEmail != null) ...[
                  const SizedBox(height: 2),
                  const BodyText(
                    text: "Inbox Mail",
                  ),
                  SubText(text: userSummary.systemEmail!),
                  const SizedBox(height: 6),
                ],
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
            if (connectivityService.isOnline)
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'update') {
                    onUpdate();
                  } else if (value == 'delete') {
                    onDelete();
                  } else if (value == 'copyMail') {
                    Clipboard.setData(
                            ClipboardData(text: userSummary.systemEmail!))
                        .then((_) {
                      CustomSnackbar.showCustomSnackbar(
                        context: context,
                        message: "Email copied",
                        backgroundColor: Theme.of(context)
                            .extension<CustomColors>()!
                            .success,
                      );
                    });
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
                  if (userSummary.systemEmail != null)
                    PopupMenuItem(
                      value: 'copyMail',
                      child: Row(
                        children: [
                          Icon(Icons.copy_rounded,
                              size: 20,
                              color: Theme.of(context).colorScheme.onSecondary),
                          BtnText(
                            text: "Copy Mail",
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
                            size: 20,
                            color: Theme.of(context).colorScheme.error),
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
