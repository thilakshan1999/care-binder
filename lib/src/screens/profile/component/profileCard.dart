import 'package:care_sync/src/theme/customColors.dart';
import 'package:flutter/material.dart';

import '../../../component/text/primaryText.dart';

class ProfileCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool showLogout;
  const ProfileCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.showLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Theme.of(context).extension<CustomColors>()?.primarySurface,
      child: ListTile(
        leading: Icon(
          icon,
          color: showLogout
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.primary,
          size: 28,
        ),
        title: PrimaryText(text: title),
        trailing:
            showLogout ? null : const Icon(Icons.arrow_forward_ios, size: 20),
        onTap: onTap,
      ),
    );
  }
}
