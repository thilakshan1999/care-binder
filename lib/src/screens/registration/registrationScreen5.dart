import 'package:care_sync/src/bloc/registrationBloc.dart';
import 'package:care_sync/src/component/datePicker/dateTimePickerField.dart';
import 'package:care_sync/src/screens/main/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/questionLayout/QuestionLayout.dart';
import '../../component/text/errorText.dart';

class RegistrationScreen5 extends StatefulWidget {
  const RegistrationScreen5({super.key});

  @override
  State<RegistrationScreen5> createState() => _RegistrationScreen5State();
}

class _RegistrationScreen5State extends State<RegistrationScreen5> {
  DateTime? dateOfBirth;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return QuestionLayout(
      question: "What is your date of birth?",
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DateTimePickerField(
                  initialDateTime: dateOfBirth,
                  onChanged: (date) {
                    setState(() {
                      dateOfBirth = date;
                    });
                  }),
              if (errorMessage != null)
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ErrorText(text: errorMessage!)),
            ],
          )),
      isLoading: false,
      btnLabel: 'Register',
      onClickBtn: () {
        if (dateOfBirth == null) {
          setState(() {
            errorMessage = "Please select a date before continuing.";
          });
        } else {
          debugPrint("Selected role: $dateOfBirth");
          context.read<RegistrationBloc>().setDateOfBirth(dateOfBirth!);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
          );
        }
      },
    );
  }
}
