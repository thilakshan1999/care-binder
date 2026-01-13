import 'package:care_sync/src/bloc/userBloc.dart';
import 'package:care_sync/src/component/appBar/appBar.dart';
import 'package:care_sync/src/component/btn/primaryBtn/priamaryLoadingBtn.dart';
import 'package:care_sync/src/component/contraintBox/maxWidthConstraintBox.dart';
import 'package:care_sync/src/component/snakbar/customSnakbar.dart';
import 'package:care_sync/src/component/text/btnText.dart';
import 'package:care_sync/src/component/text/primaryText.dart';
import 'package:care_sync/src/component/textField/simpleTextField/simpleTextField.dart';
import 'package:care_sync/src/screens/forgotPassword/forgotPasswordScreen2.dart';
import 'package:care_sync/src/screens/registration/registrationScreen.dart';
import 'package:care_sync/src/service/api/httpService.dart';
import 'package:care_sync/src/theme/customColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPassword1Screen extends StatefulWidget {
  const ForgotPassword1Screen({super.key});

  @override
  State<ForgotPassword1Screen> createState() => _ForgotPassword1ScreenState();
}

class _ForgotPassword1ScreenState extends State<ForgotPassword1Screen> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String email = "";
  late final HttpService httpService;

  @override
  void initState() {
    super.initState();
    httpService = HttpService(context.read<UserBloc>());
  }

  Future<void> sendOtp() async {
    final theme = Theme.of(context);

    try {
      final result = await httpService.userService.forgotPassword(email);

      if (mounted) {
        if (result.success) {
          CustomSnackbar.showCustomSnackbar(
            context: context,
            message: result.message,
            backgroundColor:
                Theme.of(context).extension<CustomColors>()!.success,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ForgotPassword2Screen(
                      email: email,
                    )),
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
        tittle: "Forgot Password",
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
                    const PrimaryText(text: "Enter Email Address"),
                    const SizedBox(height: 16),
                    SimpleTextField(
                      initialText: "",
                      keyboardType: TextInputType.emailAddress,
                      labelText: 'Email',
                      readOnly: isLoading,
                      onChanged: (value) {
                        email = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email cannot be empty';
                        }
                        // Simple email regex
                        final emailRegex =
                            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    PrimaryLoadingBtn(
                      loading: isLoading,
                      label: "Send Otp",
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          setState(() {
                            isLoading = true;
                          });
                          sendOtp();
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
                      text: "Don’t have an account? ",
                      color: Theme.of(context).colorScheme.onSurface),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegistrationScreen()),
                        );
                      },
                      child: BtnText(
                          fontWeight: FontWeight.bold,
                          text: "SignUp",
                          color: Theme.of(context).colorScheme.primary)),
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
