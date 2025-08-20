import 'package:care_sync/src/theme/customColors.dart';
import 'package:flutter/material.dart';
import 'package:chips_choice/chips_choice.dart';

class DocumentFilterBar extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const DocumentFilterBar({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onChanged,
  });

  List<C2Choice<int>> _buildChoices() {
    return C2Choice.listFrom<int, String>(
      source: categories,
      value: (i, v) => i,
      label: (i, v) => v,
      tooltip: (i, v) => v,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChipsChoice<int>.single(
      value: selectedIndex,
      onChanged: onChanged,
      choiceItems: _buildChoices(),
      choiceCheckmark: true,
      // Correct style API for v3.x
      choiceStyle: C2ChipStyle.filled(
        color: Theme.of(context).extension<CustomColors>()?.primarySurface,
        elevation: 3, // strength of shadow
        shadowColor: Colors.black.withOpacity(0.25),
        foregroundColor: theme.colorScheme.onSurface,
        foregroundStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),

        borderRadius: const BorderRadius.all(Radius.circular(20)),
        selectedStyle: C2ChipStyle(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
      ),
      //  wrapped: true,
    );
  }
}
