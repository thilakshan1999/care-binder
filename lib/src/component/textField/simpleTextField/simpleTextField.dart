import 'package:flutter/material.dart';

class SimpleTextField extends StatefulWidget {
  final String initialText;
  final String labelText;
  final void Function(String)? onChanged;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final String? suffixText;

  const SimpleTextField({
    super.key,
    required this.initialText,
    required this.onChanged,
    this.labelText = 'Text',
    this.keyboardType = TextInputType.text,
    this.validator,
    this.controller,
    this.suffixText,
  });

  @override
  State<SimpleTextField> createState() => _SimpleTextFieldState();
}

class _SimpleTextFieldState extends State<SimpleTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      focusNode: _focusNode,
      controller: widget.controller,
      initialValue: widget.controller != null ? null : widget.initialText,
      onChanged: widget.onChanged,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        isDense: true,
        border: const OutlineInputBorder(),
        labelText: widget.labelText,
        alignLabelWithHint: true,
        suffixText: widget.suffixText,
        labelStyle: TextStyle(
          height: 1,
          letterSpacing: 0.5,
          fontSize: _focusNode.hasFocus ? 16 : 14,
          fontWeight: FontWeight.w600,
          color: _focusNode.hasFocus
              ? theme.colorScheme.primary
              : theme.colorScheme.onSecondary,
        ),
      ),
      style: TextStyle(
        height: 1.5,
        letterSpacing: 0.5,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}
