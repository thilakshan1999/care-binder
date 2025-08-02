import 'package:flutter/material.dart';

class MultiLineTextField extends StatefulWidget {
  final String initialText;
  final String labelText;
  final ValueChanged<String> onChanged;

  const MultiLineTextField({
    super.key,
    required this.initialText,
    required this.onChanged,
    this.labelText = 'Text',
  });

  @override
  State<MultiLineTextField> createState() => _MultiLineTextFieldState();
}

class _MultiLineTextFieldState extends State<MultiLineTextField> {
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
      initialValue: widget.initialText,
      onChanged: widget.onChanged,
      keyboardType: TextInputType.multiline,
      minLines: 5,
      maxLines: null,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: widget.labelText,
        alignLabelWithHint: true,
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
      textInputAction: TextInputAction.done,
    );
  }
}
