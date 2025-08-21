import 'package:care_sync/src/bloc/registrationBloc.dart';
import 'package:care_sync/src/component/text/errorText.dart';
import 'package:care_sync/src/component/text/primaryText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/questionLayout/QuestionLayout.dart';
import '../../models/enums/userRole.dart';
import 'registrationScreen2.dart';

class RegistrationScreen1 extends StatefulWidget {
  const RegistrationScreen1({super.key});

  @override
  State<RegistrationScreen1> createState() => _RegistrationScreen1State();
}

class _RegistrationScreen1State extends State<RegistrationScreen1> {
  UserRole? selectedRole;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return QuestionLayout(
      question: "Are you the patient or a caregiver?",
      onClickBack: () {
        context.read<RegistrationBloc>().clear();
        Navigator.pop(context);
      },
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // Patient Option
          RadioListTile<UserRole>(
            value: UserRole.PATIENT,
            groupValue: selectedRole,
            title: const PrimaryText(text: "I am the patient"),
            activeColor: Theme.of(context).primaryColor,
            onChanged: (value) {
              setState(() {
                selectedRole = value;
                errorMessage = null;
              });
            },
          ),

          // Caregiver Option
          RadioListTile<UserRole>(
            value: UserRole.CAREGIVER,
            groupValue: selectedRole,
            title: const PrimaryText(text: "I am the caregiver"),
            activeColor: Theme.of(context).primaryColor,
            onChanged: (value) {
              setState(() {
                selectedRole = value;
                errorMessage = null;
              });
            },
          ),

          // Error message (if any)
          if (errorMessage != null)
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ErrorText(text: errorMessage!)),
        ],
      ),
      isLoading: false,
      btnLabel: 'Next',
      onClickBtn: () {
        if (selectedRole == null) {
          setState(() {
            errorMessage = "Please select an option before continuing.";
          });
        } else {
          debugPrint("Selected role: $selectedRole");
          context.read<RegistrationBloc>().setRole(selectedRole!);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RegistrationScreen2(),
            ),
          );
        }
      },
    );
  }
}
