import 'package:care_sync/src/component/bottomSheet/bottomSheet.dart';
import 'package:care_sync/src/theme/customColors.dart';
import 'package:flutter/material.dart';

class FilterIcon extends StatelessWidget {
  final Widget sheet;
  const FilterIcon({super.key, required this.sheet});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 36,
      width: 36,
      decoration: BoxDecoration(
        color: Theme.of(context).extension<CustomColors>()?.primarySurface,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.filter_list_rounded),
        color: Theme.of(context).colorScheme.onSurface,
        iconSize: 22,
        onPressed: () {
          CustomBottomSheet.show(context: context, child: sheet);
        },
      ),
    );
  }
}
