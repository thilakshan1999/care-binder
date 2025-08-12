import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';

class SimpleDropdownField<T extends Enum> extends StatefulWidget {
  final T initialValue;
  final List<T> values;
  final String labelText;
  final ValueChanged<T> onChanged;

  const SimpleDropdownField({
    super.key,
    required this.initialValue,
    required this.values,
    required this.onChanged,
    this.labelText = 'Select',
  });

  @override
  State<SimpleDropdownField<T>> createState() => _SimpleDropdownFieldState<T>();
}

class _SimpleDropdownFieldState<T extends Enum>
    extends State<SimpleDropdownField<T>> {
  late SingleValueDropDownController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _controller = SingleValueDropDownController(
      data: DropDownValueModel(
        name: _formatEnumName(widget.initialValue.name),
        value: widget.initialValue,
      ),
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
      clearOption: false,
      enableSearch: false,
      dropDownList: widget.values
          .map((e) => DropDownValueModel(
                name: _formatEnumName(e.name),
                value: e,
              ))
          .toList(),
      dropDownItemCount: 5,
      listSpace: 4,
      onChanged: (val) {
        if (val is DropDownValueModel && val.value is T) {
          widget.onChanged(val.value as T);
        }
      },
      textFieldDecoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: widget.labelText,
        alignLabelWithHint: true,
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

  String _formatEnumName(String name) {
    return name
        .toLowerCase()
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
