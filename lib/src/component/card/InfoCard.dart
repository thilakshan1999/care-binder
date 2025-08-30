import 'package:care_sync/src/component/badge/simpleBadge.dart';
import 'package:care_sync/src/component/text/btnText.dart';
import 'package:care_sync/src/component/text/primaryText.dart';
import 'package:care_sync/src/component/text/subText.dart';
import 'package:care_sync/src/models/enums/entityStatus.dart';
import 'package:care_sync/src/utils/iconAndColorUtils.dart';
import 'package:care_sync/src/utils/textFormatUtils.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class InfoCard extends StatelessWidget {
  final String icon;
  final String mainText;
  final String? subText;
  final EntityStatus? status;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isEditable;

  const InfoCard({
    super.key,
    required this.icon,
    required this.mainText,
    required this.subText,
    required this.onTap,
    this.status,
    this.onEdit,
    this.onDelete,
    this.isEditable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Iconify(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(text: mainText),
                    if (subText != null) ...[
                      const SizedBox(height: 4),
                      SubText(text: subText!)
                    ],
                    if (status != null) ...[
                      const SizedBox(height: 6),
                      SimpleBadge(
                        color: IconAndColorUtils.getStatusColor(status!),
                        child: Text(
                          TextFormatUtils.formatEnum(status),
                          style: TextStyle(
                            color: IconAndColorUtils.getStatusColor(status!),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isEditable && (onDelete != null || onEdit != null))
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit!();
                    } else if (value == 'delete') {
                      onDelete!();
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    if (onEdit != null)
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit,
                                size: 20,
                                color:
                                    Theme.of(context).colorScheme.onSecondary),
                            BtnText(
                              text: "Edit",
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontWeight: FontWeight.w400,
                            )
                          ],
                        ),
                      ),
                    if (onDelete != null)
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
      ),
    );
  }
}
