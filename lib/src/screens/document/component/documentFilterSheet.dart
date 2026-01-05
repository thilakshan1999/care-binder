import 'package:care_sync/src/component/btn/primaryBtn/primaryBtn.dart';
import 'package:care_sync/src/component/dropdown/simpleEnumDropdown.dart';
import 'package:care_sync/src/component/text/sectionTittleText.dart';
import 'package:care_sync/src/models/enums/documentFilterOption.dart';
import 'package:flutter/material.dart';

class DocumentFilterSheet extends StatefulWidget {
  final DocumentFilterOption initialOption;
  final SortOrder initialSortOptions;
  final void Function(DocumentFilterOption, SortOrder) onApply;

  const DocumentFilterSheet({
    required this.initialOption,
    required this.initialSortOptions,
    required this.onApply,
    super.key,
  });

  @override
  State<DocumentFilterSheet> createState() => _DocumentFilterSheetState();
}

class _DocumentFilterSheetState extends State<DocumentFilterSheet> {
  final _formKey = GlobalKey<FormState>();
  late DocumentFilterOption currentOption = widget.initialOption;
  late SortOrder currentSortOptions = widget.initialSortOptions;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 12),
                const SectionTittleText(text: "Filter Documents"),
                const SizedBox(height: 20),
                SimpleEnumDropdownField(
                  labelText: "Filter By",
                  initialValue: currentOption,
                  values: DocumentFilterOption.values,
                  onChanged: (value) {
                    currentOption = value!;
                  },
                ),
                const SizedBox(height: 20),
                SimpleEnumDropdownField(
                  labelText: "Sort By",
                  initialValue: currentSortOptions,
                  values: SortOrder.values,
                  onChanged: (value) {
                    currentSortOptions = value!;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                PrimaryBtn(
                  label: 'Apply Filters',
                  onPressed: () {
                    widget.onApply(currentOption, currentSortOptions);
                    Navigator.pop(context);
                  },
                ),
              ],
            ))
      ],
    );
  }
}
