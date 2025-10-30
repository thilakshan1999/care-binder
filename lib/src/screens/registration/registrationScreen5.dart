import 'package:care_sync/src/bloc/registrationBloc.dart';
import 'package:care_sync/src/component/datePicker/dateTimePickerField.dart';
import 'package:care_sync/src/screens/document/documentScreen.dart';
import 'package:care_sync/src/screens/main/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/userBloc.dart';
import '../../component/questionLayout/QuestionLayout.dart';
import '../../component/snakbar/customSnakbar.dart';
import '../../component/text/errorText.dart';
import '../../service/api/httpService.dart';

class RegistrationScreen5 extends StatefulWidget {
  const RegistrationScreen5({super.key});

  @override
  State<RegistrationScreen5> createState() => _RegistrationScreen5State();
}

class _RegistrationScreen5State extends State<RegistrationScreen5> {
  bool isLoading = false;
  DateTime? dateOfBirth;
  String? errorMessage;

  late final HttpService httpService;

@override
  void initState() {
    super.initState();
    httpService = HttpService(context.read<UserBloc>());
  }
  
  Future<void> _register() async {
    final theme = Theme.of(context);

    try {
      final result = await httpService.userService
          .register(context.read<RegistrationBloc>().state);

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
          context.read<RegistrationBloc>().setDateOfBirth(dateOfBirth!);
          setState(() {
            isLoading = false;
          });
          _register();
        }
      },
    );
  }
}
