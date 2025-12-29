import 'package:care_sync/src/bloc/userBloc.dart';
import 'package:care_sync/src/screens/careManagement/patientListScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/enums/userRole.dart';
import 'documentListScreen.dart';

class DocumentScreen extends StatelessWidget {
  const DocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userState = context.read<UserBloc>().state;
    final role = userState.role;

    if (role == UserRole.PATIENT) {
      return const DocumentListScreen();
    } else if (role == UserRole.CAREGIVER) {
      return PatientListScreen(
        tittle: 'Medical Documents',
        onTap: (patient, permission) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DocumentListScreen(
                patient: patient,
                permission: permission,
              ),
            ),
          );
        },
      );
    } else {
      return const Scaffold(
        body: Center(child: Text("Unsupported role")),
      );
    }
  }
}
