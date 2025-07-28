import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'customColors.dart';

ThemeData lightTheme = ThemeData(
  textTheme: GoogleFonts.interTextTheme(),
  colorScheme: const ColorScheme.light(
    primary: Color.fromARGB(255, 30, 136, 229),
    secondary: Color.fromARGB(255, 26, 188, 156),
    surface: Color.fromARGB(255, 249, 250, 251),
    error: Color.fromARGB(255, 235, 87, 87),
    onPrimary: Color.fromARGB(255, 255, 255, 255),
    onSecondary: Color.fromARGB(255, 126, 126, 126),
    onSurface: Color.fromARGB(255, 31, 41, 55),
    onError: Color.fromARGB(255, 255, 255, 255),
    brightness: Brightness.light,
  ),
  extensions: const [
    CustomColors(
      success: Color.fromARGB(255, 39, 174, 96),
      primarySurface: Color.fromARGB(255, 255, 255, 255),
      border: Color.fromARGB(255, 209, 213, 219),
      focusBorder: Color.fromARGB(255, 47, 128, 237),
      errorBorder: Color.fromARGB(255, 235, 87, 87),
      disableBorder: Color.fromARGB(255, 229, 231, 235),
      placeholderText: Color.fromARGB(255, 189, 189, 189),
    ),
  ],
  useMaterial3: true,
);
