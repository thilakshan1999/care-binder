import 'package:flutter/material.dart';

class ProfileIconButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ProfileIconButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: CircleAvatar(
        radius: 16,
        backgroundColor:
            Theme.of(context).colorScheme.onPrimary.withOpacity(0.9),
        child: Icon(
          size: 24,
          Icons.person,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
