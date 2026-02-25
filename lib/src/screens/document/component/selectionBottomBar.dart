import 'dart:ui';

import 'package:care_sync/src/component/text/btnText.dart';
import 'package:flutter/material.dart';

class SelectionBottomBar extends StatelessWidget {
  final int selectedCount;
  final bool fullAccess;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;

  const SelectionBottomBar({
    super.key,
    required this.fullAccess,
    required this.selectedCount,
    this.onShare,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, -2),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.ios_share,
                    size: 28, color: Theme.of(context).colorScheme.surface),
                onPressed: onShare,
              ),
              BtnText(
                  text: "$selectedCount Document Selected",
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.surface),
              if (fullAccess) ...[
                IconButton(
                  icon: Icon(Icons.delete_outline,
                      size: 28, color: Theme.of(context).colorScheme.error),
                  onPressed: onDelete,
                ),
              ] else ...[
                const SizedBox(
                  width: 28,
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
