import 'dart:ui';

import 'package:care_sync/src/component/text/btnText.dart';
import 'package:care_sync/src/service/connectivityService.dart';
import 'package:flutter/material.dart';

class SelectionBottomBar extends StatelessWidget {
  final int selectedCount;
  final bool fullAccess;
  final bool isLoading;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;

  const SelectionBottomBar({
    super.key,
    required this.fullAccess,
    required this.selectedCount,
    required this.isLoading,
    this.onShare,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 70,
          alignment: const Alignment(0, -1),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
                icon: isLoading
                    ? SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      )
                    : Icon(Icons.ios_share,
                        size: 28, color: Theme.of(context).colorScheme.surface),
                onPressed: isLoading ? null : onShare,
              ),
              BtnText(
                  text: "$selectedCount Document Selected",
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.surface),
              if (fullAccess && connectivityService.isOnline) ...[
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
