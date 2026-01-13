import 'package:care_sync/src/bloc/userBloc.dart';
import 'package:care_sync/src/component/appBar/appBar.dart';
import 'package:care_sync/src/component/btn/primaryBtn/priamaryLoadingBtn.dart';
import 'package:care_sync/src/component/contraintBox/maxWidthConstraintBox.dart';
import 'package:care_sync/src/component/snakbar/customSnakbar.dart'
    show CustomSnackbar;
import 'package:care_sync/src/component/text/primaryText.dart';
import 'package:care_sync/src/component/textField/password/passwordTextField.dart';
import 'package:care_sync/src/screens/login/loginScreen.dart';
import 'package:care_sync/src/service/api/httpService.dart';
import 'package:care_sync/src/theme/customColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

class ForgotPassword3Screen extends StatefulWidget {
  final String email;
  final String otp;
  const ForgotPassword3Screen(
      {super.key, required this.email, required this.otp});

  @override
  State<ForgotPassword3Screen> createState() => _ForgotPassword3ScreenState();
}

class _ForgotPassword3ScreenState extends State<ForgotPassword3Screen> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String password = "";
  late final HttpService httpService;

  @override
  void initState() {
    super.initState();
    httpService = HttpService(context.read<UserBloc>());
  }

  Future<void> updatePassword() async {
    final theme = Theme.of(context);

    try {
      final result = await httpService.userService.resetPassword(
        email: widget.email,
        otp: widget.otp,
        newPassword: password,
      );

      if (mounted) {
        if (result.success) {
          CustomSnackbar.showCustomSnackbar(
            context: context,
            message: result.message,
            backgroundColor:
                Theme.of(context).extension<CustomColors>()!.success,
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => route.isFirst, // keep the root route
          );
        } else {
          CustomSnackbar.showCustomSnackbar(
            context: context,
            message: result.message,
            backgroundColor: theme.colorScheme.error,
          );
        }
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        CustomSnackbar.showCustomSnackbar(
          context: context,
          message: e.toString(),
          backgroundColor: theme.colorScheme.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        tittle: "New Password",
        showProfile: false,
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: MaxWidthConstrainedBox(
          maxWidth: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PrimaryText(text: "New Password"),
                    const SizedBox(
                      height: 10,
                    ),
                    PasswordTextField(
                      initialText: "",
                      labelText: 'Enter your password',
                      readOnly: isLoading,
                      onChanged: (value) {
                        password = value;
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Password cannot be empty';
                        }

                        if (value.trim().length < 8) {
                          return 'Password must be at least 8 characters';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const PrimaryText(text: "Confirm Password"),
                    const SizedBox(
                      height: 10,
                    ),
                    PasswordTextField(
                      initialText: "",
                      labelText: 'Repeat Password',
                      readOnly: isLoading,
                      onChanged: (value) {},
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Confirm Password cannot be empty';
                        }

                        if (value.trim() != password.trim()) {
                          return 'Passwords do not match';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    PrimaryLoadingBtn(
                      loading: isLoading,
                      label: "Update Password",
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          setState(() {
                            isLoading = true;
                          });
                          updatePassword();
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
