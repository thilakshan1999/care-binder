import 'package:care_sync/src/component/text/subText.dart';
import 'package:flutter/material.dart';

import '../../../component/badge/simpleBadge.dart';
import '../../../component/text/primaryText.dart';
import '../../../models/user/careGiverAssignment.dart';
import '../../../theme/customColors.dart';
import '../../../utils/iconAndColorUtils.dart';
import '../../../utils/textFormatUtils.dart';

class PatientCard extends StatelessWidget {
  final CareGiverAssignment member;
  final VoidCallback onTap;
  const PatientCard({
    super.key,
    required this.member,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Theme.of(context).extension<CustomColors>()?.primarySurface,
      child: ListTile(
        leading: Icon(
          Icons.elderly,
          color: Theme.of(context).colorScheme.primary,
          size: 32,
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText(text: member.patient.name),
              const SizedBox(height: 4),
              SubText(
                text: member.patient.email,
              ),
              const SizedBox(height: 4),
              SimpleBadge(
                color: IconAndColorUtils.getPermissionColor(member.permission),
                child: Text(
                  TextFormatUtils.formatEnum(member.permission),
                  style: TextStyle(
                    color:
                        IconAndColorUtils.getPermissionColor(member.permission),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 20),
        onTap: onTap,
      ),
    );
  }
}
