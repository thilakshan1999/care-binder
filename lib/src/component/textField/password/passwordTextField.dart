import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final String initialText;
  final String labelText;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool readOnly;

  const PasswordTextField({
    super.key,
    required this.initialText,
    required this.onChanged,
    this.labelText = 'Password',
    this.validator,
    this.controller,
    this.readOnly = false,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  late FocusNode _focusNode;
  bool _obscureText = true; // 👁️ toggle state

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
      readOnly: widget.readOnly,
      obscureText: _obscureText, // hides or shows password
      initialValue: widget.controller != null ? null : widget.initialText,
      onChanged: widget.onChanged,
      validator: widget.validator,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        isDense: true,
        border: const OutlineInputBorder(),
        labelText: widget.labelText,
        alignLabelWithHint: true,
        // 👁️ eye button
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: _focusNode.hasFocus
                ? theme.colorScheme.primary
                : theme.colorScheme.onSecondary,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
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
