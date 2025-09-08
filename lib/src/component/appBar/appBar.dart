import 'package:care_sync/src/screens/profile/profileScreen.dart';
import 'package:flutter/material.dart';

import '../btn/profile/profileIconButton.dart';
import '../text/screenTittleText.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String tittle;
  final bool showBackButton;
  final bool showProfile;
  const CustomAppBar({
    super.key,
    required this.tittle,
    this.showBackButton = false,
    this.showProfile = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: ScreenTittleText(
        text: tittle,
      ),
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios,
                  color: Theme.of(context).colorScheme.onPrimary),
              onPressed: () => Navigator.pop(context),
            )
          : const SizedBox.shrink(),
      actions: [
        if (showProfile)
          ProfileIconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              const Color.fromARGB(255, 46, 161, 228),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
