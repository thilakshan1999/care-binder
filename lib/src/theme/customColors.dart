import 'package:flutter/material.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  final Color success;
  final Color primarySurface;
  final Color border;
  final Color focusBorder;
  final Color errorBorder;
  final Color disableBorder;
  final Color placeholderText;

  const CustomColors({
    required this.success,
    required this.primarySurface,
    required this.border,
    required this.focusBorder,
    required this.errorBorder,
    required this.disableBorder,
    required this.placeholderText,
  });

  @override
  CustomColors copyWith(
      {Color? success,
      Color? primarySurface,
      Color? border,
      Color? focusBorder,
      Color? errorBorder,
      Color? disableBorder,
      Color? placeholderText,
      Color? textFieldText}) {
    return CustomColors(
      success: success ?? this.success,
      primarySurface: primarySurface ?? this.primarySurface,
      border: border ?? this.border,
      focusBorder: focusBorder ?? this.focusBorder,
      errorBorder: errorBorder ?? this.errorBorder,
      disableBorder: disableBorder ?? this.disableBorder,
      placeholderText: placeholderText ?? this.placeholderText,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      success: Color.lerp(success, other.success, t)!,
      primarySurface: Color.lerp(primarySurface, other.primarySurface, t)!,
      border: Color.lerp(border, other.border, t)!,
      focusBorder: Color.lerp(focusBorder, other.focusBorder, t)!,
      errorBorder: Color.lerp(errorBorder, other.errorBorder, t)!,
      disableBorder: Color.lerp(disableBorder, other.disableBorder, t)!,
      placeholderText: Color.lerp(placeholderText, other.placeholderText, t)!,
    );
  }
}
