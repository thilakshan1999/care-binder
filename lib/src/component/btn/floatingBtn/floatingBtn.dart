import 'package:care_sync/src/theme/customColors.dart';
import 'package:flutter/material.dart';

class CustomFloatingBtn extends StatelessWidget {
  final VoidCallback onPressed;
  const CustomFloatingBtn({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor:
            Theme.of(context).extension<CustomColors>()?.primarySurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3,
        child: Icon(
          Icons.add,
          size: 36,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
