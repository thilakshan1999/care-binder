import 'dart:async';

import 'package:care_sync/src/bloc/userBloc.dart';
import 'package:care_sync/src/component/appBar/appBar.dart';
import 'package:care_sync/src/component/btn/primaryBtn/priamaryLoadingBtn.dart';
import 'package:care_sync/src/component/contraintBox/maxWidthConstraintBox.dart';
import 'package:care_sync/src/component/snakbar/customSnakbar.dart'
    show CustomSnackbar;
import 'package:care_sync/src/component/text/btnText.dart';
import 'package:care_sync/src/component/text/primaryText.dart';
import 'package:care_sync/src/component/textField/simpleTextField/simpleTextField.dart';
import 'package:care_sync/src/screens/forgotPassword/forgotPasswordScreen3.dart';
import 'package:care_sync/src/service/api/httpService.dart';
import 'package:care_sync/src/theme/customColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPassword2Screen extends StatefulWidget {
  final String email;
  const ForgotPassword2Screen({super.key, required this.email});

  @override
  State<ForgotPassword2Screen> createState() => _ForgotPassword2ScreenState();
}

class _ForgotPassword2ScreenState extends State<ForgotPassword2Screen> {
  bool isLoading = false;
  bool canResend = true;
  int remainingSeconds = 0;
  Timer? _timer;

  final _formKey = GlobalKey<FormState>();
  String otp = "";
  late final HttpService httpService;

  @override
  void initState() {
    super.initState();
    httpService = HttpService(context.read<UserBloc>());
  }

  Future<void> sendOtp() async {
    final theme = Theme.of(context);

    try {
      final result = await httpService.userService.forgotPassword(widget.email);

      if (mounted) {
        if (result.success) {
          CustomSnackbar.showCustomSnackbar(
            context: context,
            message: result.message,
            backgroundColor:
                Theme.of(context).extension<CustomColors>()!.success,
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

  Future<void> verifyOtp() async {
    final theme = Theme.of(context);

    try {
      final result = await httpService.userService.verifyOtp(widget.email, otp);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ForgotPassword3Screen(
                  email: widget.email,
                  otp: otp,
                )),
      );
      if (mounted) {
        if (result.success) {
          CustomSnackbar.showCustomSnackbar(
            context: context,
            message: result.message,
            backgroundColor:
                Theme.of(context).extension<CustomColors>()!.success,
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

  void startResendTimer() {
    setState(() {
      canResend = false;
      remainingSeconds = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds == 0) {
        timer.cancel();
        setState(() {
          canResend = true;
        });
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        tittle: "Verification",
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
                  children: [
                    const PrimaryText(text: "Enter Verification Code"),
                    const SizedBox(height: 16),
                    SimpleTextField(
                      initialText: "",
                      keyboardType: TextInputType.number,
                      labelText: 'Otp',
                      readOnly: isLoading,
                      onChanged: (value) {
                        otp = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'OTP cannot be empty';
                        }
                        // Check if it's exactly 6 digits
                        final otpRegex = RegExp(r'^\d{6}$');
                        if (!otpRegex.hasMatch(value)) {
                          return 'OTP must be a 6-digit number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    PrimaryLoadingBtn(
                      loading: isLoading,
                      label: "Verify",
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          setState(() {
                            isLoading = true;
                          });
                          verifyOtp();
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BtnText(
                      text: "Didn't receive a code? ",
                      color: Theme.of(context).colorScheme.onSurface),
                  canResend
                      ? GestureDetector(
                          onTap: () {
                            startResendTimer();
                            sendOtp();
                          },
                          child: BtnText(
                            fontWeight: FontWeight.bold,
                            text: "Resend",
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      : BtnText(
                          fontWeight: FontWeight.bold,
                          text: "Resend in ${remainingSeconds}s",
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
