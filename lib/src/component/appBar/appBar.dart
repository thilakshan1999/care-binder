import 'package:flutter/material.dart';

import '../text/screenTittleText.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String tittle;
  final bool showBackButton;
  const CustomAppBar({
    super.key,
    required this.tittle,
    this.showBackButton = false,
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
