import 'package:care_sync/src/bloc/userBloc.dart';
import 'package:care_sync/src/models/apiResponse.dart';
import 'package:care_sync/src/screens/login/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../snakbar/customSnakbar.dart';

class ApiHandler {
  static Future<void> handleApiCall<T>({
    required BuildContext context,
    required Future<ApiResponse<T>> Function() request,
    required void Function(T data, String message) onSuccess,
    void Function(String message, String? title)? onError,
    VoidCallback? onFinally,
  }) async {
    final navigator = Navigator.of(context);
    final theme = Theme.of(context);

    try {
      final result = await request();

      if (result.success) {
        onSuccess(result.data as T, result.message);
      } else if (result.errorTittle == "Unauthorized") {
        context.read<UserBloc>().clear();
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false,
        );
      } else {
        if (onError != null) {
          onError(result.message, result.errorTittle);
        } else {
          CustomSnackbar.showCustomSnackbar(
            context: context,
            message: result.message,
            backgroundColor: theme.colorScheme.error,
          );
        }
      }
    } catch (e) {
      if (onError != null) {
        onError('$e', 'Unexpected Error');
      } else {
        CustomSnackbar.showCustomSnackbar(
          context: context,
          message: '$e',
          backgroundColor: theme.colorScheme.error,
        );
      }
    } finally {
      onFinally?.call();
    }
  }
}
