import 'package:care_sync/src/bloc/userBloc.dart';
import 'package:care_sync/src/component/btn/primaryBtn/priamaryLoadingBtn.dart';
import 'package:care_sync/src/component/text/btnText.dart';
import 'package:care_sync/src/models/user/loginRequest.dart';
import 'package:care_sync/src/screens/main/mainScreen.dart';
import 'package:care_sync/src/screens/registration/registrationScreen1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/snakbar/customSnakbar.dart';
import '../../component/textField/password/passwordTextField.dart';
import '../../component/textField/simpleTextField/simpleTextField.dart';
import '../../service/api/httpService.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String password = "";
  String email = "";
  final HttpService httpService = HttpService();

  Future<void> login() async {
    final theme = Theme.of(context);

    try {
      final loginRequest = LoginRequest(email: email, password: password);
      final result = await httpService.userService.login(loginRequest);

      if (mounted) {
        if (result.success && result.data != null) {
          final auth = result.data!;

          context.read<UserBloc>().setUserFromToken(
                auth.accessToken,
                auth.refreshToken,
              );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SimpleTextField(
                      initialText: "",
                      keyboardType: TextInputType.emailAddress,
                      labelText: 'Email',
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
                    const SizedBox(height: 20),
                    PasswordTextField(
                      initialText: "",
                      labelText: "Password",
                      onChanged: (value) {
                        password = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password cannot be empty';
                        }
                        if (value.trim().length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    PrimaryLoadingBtn(
                      loading: isLoading,
                      label: "Login",
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          setState(() {
                            isLoading = true;
                          });
                          login();
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
                              builder: (context) =>
                                  const RegistrationScreen1()),
                        );
                      },
                      child: BtnText(
                          fontWeight: FontWeight.bold,
                          text: "SignUp",
                          color: Theme.of(context).colorScheme.primary)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
