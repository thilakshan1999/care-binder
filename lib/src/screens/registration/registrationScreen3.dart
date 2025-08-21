import 'package:care_sync/src/bloc/registrationBloc.dart';
import 'package:care_sync/src/screens/registration/registrationScreen4.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/questionLayout/QuestionLayout.dart';
import '../../component/textField/simpleTextField/simpleTextField.dart';

class RegistrationScreen3 extends StatefulWidget {
  const RegistrationScreen3({
    super.key,
  });

  @override
  State<RegistrationScreen3> createState() => _RegistrationScreen3State();
}

class _RegistrationScreen3State extends State<RegistrationScreen3> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String email = context.read<RegistrationBloc>().state.email ?? "";
    return QuestionLayout(
      question: "What’s your email address?",
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SimpleTextField(
            initialText: email,
            labelText: 'Email',
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              email = value;
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
        ),
      ),
      isLoading: false,
      btnLabel: 'Next',
      onClickBtn: () {
        if (_formKey.currentState?.validate() ?? false) {
          context.read<RegistrationBloc>().setEmail(email);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RegistrationScreen4(),
            ),
          );
        }
      },
    );
  }
}
