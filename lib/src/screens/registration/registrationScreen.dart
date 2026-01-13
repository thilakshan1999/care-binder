import 'package:care_sync/src/bloc/userBloc.dart';
import 'package:care_sync/src/component/appBar/appBar.dart';
import 'package:care_sync/src/component/btn/primaryBtn/priamaryLoadingBtn.dart';
import 'package:care_sync/src/component/contraintBox/maxWidthConstraintBox.dart';
import 'package:care_sync/src/component/text/bodyText.dart';
import 'package:care_sync/src/component/text/primaryText.dart';
import 'package:care_sync/src/component/text/subText.dart';
import 'package:care_sync/src/models/enums/userRole.dart';
import 'package:care_sync/src/models/user/userRegistration.dart';
import 'package:care_sync/src/screens/login/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/snakbar/customSnakbar.dart';
import '../../component/text/btnText.dart';
import '../../component/text/errorText.dart';
import '../../component/textField/password/passwordTextField.dart';
import '../../component/textField/simpleTextField/simpleTextField.dart';
import '../../service/api/httpService.dart';
import '../document/documentScreen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  UserRegistration userRegistration = UserRegistration();
  String? errorMessage;
  bool isLoading = false;

  late final HttpService httpService;

  @override
  void initState() {
    super.initState();
    httpService = HttpService(context.read<UserBloc>());
  }

  Future<void> _register() async {
    final theme = Theme.of(context);

    setState(() {
      isLoading = true;
    });

    try {
      final result = await httpService.userService.register(userRegistration);

      if (mounted) {
        if (result.success && result.data != null) {
          final auth = result.data!;

          context.read<UserBloc>().setUserFromToken(
                auth.accessToken,
                auth.refreshToken,
              );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DocumentScreen()),
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
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: const CustomAppBar(
        tittle: "Create account",
        showProfile: false,
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
                child: MaxWidthConstrainedBox(
              maxWidth: 400,
              child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SubText(text: "Please enter your details"),
                      const SizedBox(
                        height: 20,
                      ),

                      //Role
                      const PrimaryText(text: "Patient or Caregiver"),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Patient Option
                          Expanded(
                            child: RadioListTile<UserRole>(
                              value: UserRole.PATIENT,
                              dense: true,
                              groupValue: userRegistration.role,
                              title: const BodyText(text: "Patient"),
                              activeColor: Theme.of(context).primaryColor,
                              contentPadding: EdgeInsets.zero,
                              onChanged: (value) {
                                if (!isLoading) {
                                  setState(() {
                                    userRegistration.role = value;
                                    errorMessage = null;
                                  });
                                }
                              },
                            ),
                          ),

                          // Caregiver Option
                          Expanded(
                            child: RadioListTile<UserRole>(
                              value: UserRole.CAREGIVER,
                              dense: true,
                              groupValue: userRegistration.role,
                              title: const BodyText(text: "Caregiver"),
                              activeColor: Theme.of(context).primaryColor,
                              contentPadding: EdgeInsets.zero,
                              onChanged: (value) {
                                if (!isLoading) {
                                  setState(() {
                                    userRegistration.role = value;
                                    errorMessage = null;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      if (errorMessage != null)
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ErrorText(text: errorMessage!)),

                      const SizedBox(
                        height: 20,
                      ),

                      //Email
                      const PrimaryText(text: "Your Email"),
                      const SizedBox(
                        height: 10,
                      ),
                      SimpleTextField(
                        initialText: userRegistration.email ?? "",
                        labelText: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        readOnly: isLoading,
                        onChanged: (value) {
                          userRegistration.email = value;
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email cannot be empty';
                          }

                          final emailRegExp = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          );

                          if (!emailRegExp.hasMatch(value.trim())) {
                            return 'Please enter a valid email address';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      //Name
                      const PrimaryText(text: "Full name"),
                      const SizedBox(
                        height: 10,
                      ),
                      SimpleTextField(
                        initialText: userRegistration.name ?? "",
                        labelText: 'Enter your name',
                        readOnly: isLoading,
                        onChanged: (value) {
                          userRegistration.name = value;
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Name cannot be empty';
                          }
                          if (value.trim().length < 2) {
                            return 'Name must be at least 2 characters';
                          }
                          final nameRegExp = RegExp(r'^[a-zA-Z\s]+$');
                          if (!nameRegExp.hasMatch(value.trim())) {
                            return 'Name can only contain letters and spaces';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      //Password
                      const PrimaryText(text: "Password"),
                      const SizedBox(
                        height: 10,
                      ),
                      PasswordTextField(
                        initialText: userRegistration.password ?? "",
                        labelText: 'Enter your password',
                        readOnly: isLoading,
                        onChanged: (value) {
                          userRegistration.password = value;
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
                        initialText: userRegistration.password ?? "",
                        labelText: 'Repeat Password',
                        readOnly: isLoading,
                        onChanged: (value) {},
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Confirm Password cannot be empty';
                          }

                          if (value.trim() !=
                              userRegistration.password?.trim()) {
                            return 'Passwords do not match';
                          }

                          return null;
                        },
                      ),
                      //Register Btn

                      const SizedBox(
                        height: 40,
                      ),

                      PrimaryLoadingBtn(
                          loading: isLoading,
                          label: "Register",
                          onPressed: () {
                            if (userRegistration.role == null) {
                              setState(() {
                                errorMessage =
                                    "Please select an option before continuing.";
                              });
                            } else {
                              if (formKey.currentState?.validate() ?? false) {
                                _register();
                              }
                            }
                          }),

                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BtnText(
                              text: "Already have an account? ",
                              color: Theme.of(context).colorScheme.onSurface),
                          GestureDetector(
                              onTap: () {
                                if (!isLoading) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                  );
                                }
                              },
                              child: BtnText(
                                  fontWeight: FontWeight.bold,
                                  text: "Login",
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                        ],
                      )
                    ],
                  )),
            ))),
      ),
    );
  }
}
