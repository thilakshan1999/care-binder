import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CustomSnackbar {
  static void showCustomSnackbar({
    required BuildContext context,
    required String message,
    Color backgroundColor = Colors.red,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    showTopSnackBar(
      Overlay.of(context),
      Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: icon != null
              ? Row(
                  children: [
                    Icon(
                      icon,
                      color: const Color.fromARGB(255, 251, 251, 251),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 251, 251, 251),
                      ),
                    ),
                  ],
                )
              : Text(
                  message,
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 251, 251, 251),
                  ),
                ),
        ),
      ),
      animationDuration: const Duration(seconds: 1),
      displayDuration: duration,
    );
  }
}
