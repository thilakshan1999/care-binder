import 'package:care_sync/src/bloc/registrationBloc.dart';
import 'package:care_sync/src/screens/registration/registrationScreen3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/questionLayout/QuestionLayout.dart';
import '../../component/textField/simpleTextField/simpleTextField.dart';

class RegistrationScreen2 extends StatefulWidget {
  const RegistrationScreen2({super.key});

  @override
  State<RegistrationScreen2> createState() => _RegistrationScreen2State();
}

class _RegistrationScreen2State extends State<RegistrationScreen2> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String name = context.read<RegistrationBloc>().state.name ?? "";
    return QuestionLayout(
      question: "What is your full name?",
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SimpleTextField(
            initialText: name,
            labelText: 'Name',
            onChanged: (value) {
              name = value;
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
        ),
      ),
      isLoading: false,
      btnLabel: 'Next',
      onClickBtn: () {
        if (_formKey.currentState?.validate() ?? false) {
          context.read<RegistrationBloc>().setName(name);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RegistrationScreen3(),
            ),
          );
        }
      },
    );
  }
}
