import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';

import '../../utils/textFormatUtils.dart';

class SimpleEnumDropdownField<T extends Enum> extends StatefulWidget {
  final T? initialValue;
  final List<T> values;
  final String labelText;
  final ValueChanged<T?> onChanged;
  final bool clearOption;
  final bool searchOption;

  const SimpleEnumDropdownField(
      {super.key,
      required this.initialValue,
      required this.values,
      required this.onChanged,
      this.labelText = 'Select',
      this.clearOption = false,
      this.searchOption = false});

  @override
  State<SimpleEnumDropdownField<T>> createState() =>
      _SimpleEnumDropdownFieldState<T>();
}

class _SimpleEnumDropdownFieldState<T extends Enum>
    extends State<SimpleEnumDropdownField<T>> {
  late SingleValueDropDownController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialValue;

    _controller = SingleValueDropDownController(
      data: initial != null
          ? DropDownValueModel(
              name: TextFormatUtils.formatEnumName(widget.initialValue!.name),
              value: widget.initialValue,
            )
          : null,
    );

    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropDownTextField(
      controller: _controller,
      textFieldFocusNode: _focusNode,
      clearOption: widget.clearOption,
      enableSearch: widget.searchOption,
      dropDownList: widget.values
          .map((e) => DropDownValueModel(
                name: TextFormatUtils.formatEnumName(e.name),
                value: e,
              ))
          .toList(),
      dropDownItemCount: 5,
      listSpace: 4,
      onChanged: (val) {
        if (val is DropDownValueModel && val.value is T) {
          widget.onChanged(val.value as T);
        } else {
          widget.onChanged(null);
        }
      },
      textFieldDecoration: InputDecoration(
        isDense: true,
        border: const OutlineInputBorder(),
        labelText: widget.labelText,
        alignLabelWithHint: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyle(
          height: 1,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w600,
          color: _focusNode.hasFocus
              ? theme.colorScheme.primary
              : theme.colorScheme.onSecondary,
        ),
      ),
      textStyle: TextStyle(
        height: 1.5,
        letterSpacing: 0.5,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}
