import 'package:care_sync/src/bloc/userBloc.dart';
import 'package:care_sync/src/component/appBar/appBar.dart';
import 'package:care_sync/src/models/enums/userRole.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CareManagementScreen extends StatefulWidget {
  const CareManagementScreen({super.key});

  @override
  State<CareManagementScreen> createState() => _CareManagementScreenState();
}

class _CareManagementScreenState extends State<CareManagementScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    UserRole? userRole = context.read<UserBloc>().state.role;

    // Define toggle labels depending on role
    final toggleLabels = userRole == UserRole.PATIENT
        ? ["Caregivers", "Requests"]
        : ["Patients", "Sent Requests"];
    return Scaffold(
      appBar: CustomAppBar(
          tittle:
              userRole == UserRole.PATIENT ? "Patient Info" : "Caregiver Info"),
      body: Column(
        children: [
          const SizedBox(height: 16),
          ToggleButtons(
            isSelected: [selectedIndex == 0, selectedIndex == 1],
            onPressed: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            borderRadius: BorderRadius.circular(8),
            selectedColor: Colors.white,
            fillColor: Theme.of(context).colorScheme.primary,
            children: toggleLabels
                .map((label) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(label),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: selectedIndex == 0
                ? _buildFirstTab(userRole!)
                : _buildSecondTab(userRole!),
          ),
        ],
      ),
    );
  }

  Widget _buildFirstTab(UserRole role) {
    if (role == UserRole.PATIENT) {
      // Patient → Caregivers list
      return const Center(child: Text("Caregivers list here"));
    } else {
      // Caregiver → Patients list
      return const Center(child: Text("Patients list here"));
    }
  }

  Widget _buildSecondTab(UserRole role) {
    if (role == UserRole.PATIENT) {
      // Patient → Requests received
      return const Center(child: Text("Requests received here"));
    } else {
      // Caregiver → Requests sent
      return const Center(child: Text("Requests sent here"));
    }
  }
}
