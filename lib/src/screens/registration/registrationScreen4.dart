import 'package:care_sync/src/bloc/registrationBloc.dart';
import 'package:care_sync/src/component/textField/password/passwordTextField.dart';
import 'package:care_sync/src/screens/registration/registrationScreen5.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/questionLayout/QuestionLayout.dart';

class RegistrationScreen4 extends StatefulWidget {
  const RegistrationScreen4({
    super.key,
  });

  @override
  State<RegistrationScreen4> createState() => _RegistrationScreen4State();
}

class _RegistrationScreen4State extends State<RegistrationScreen4> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String password = context.read<RegistrationBloc>().state.password ?? "";
    return QuestionLayout(
      question: "Create a password",
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                PasswordTextField(
                  initialText: password,
                  labelText: 'Password',
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
                PasswordTextField(
                  initialText: "",
                  labelText: 'Confirm Password',
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
              ],
            )),
      ),
      isLoading: false,
      btnLabel: 'Next',
      onClickBtn: () {
        if (_formKey.currentState?.validate() ?? false) {
          context.read<RegistrationBloc>().setPassword(password);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RegistrationScreen5(),
            ),
          );
        }
      },
    );
  }
}
