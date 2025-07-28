import 'package:flutter/material.dart';

import '../text/screenTittleText.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String tittle;
  const CustomAppBar({super.key, required this.tittle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: ScreenTittleText(
        text: tittle,
      ),
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
