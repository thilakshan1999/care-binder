import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:care_sync/src/bloc/userBloc.dart';
import 'package:care_sync/src/component/appBar/appBar.dart';
import 'package:care_sync/src/models/enums/userRole.dart';
import 'package:care_sync/src/screens/careManagement/component/careRelationshipList.dart';
import 'package:care_sync/src/screens/careManagement/component/requestList.dart';
import 'package:care_sync/src/screens/careManagement/component/requestSendSheet.dart';
import 'package:care_sync/src/theme/customColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/bottomSheet/bottomSheet.dart';
import '../../component/btn/floatingBtn/floatingBtn.dart';

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
        : ["Patients", "Requests"];

    return Scaffold(
      appBar: CustomAppBar(
          showBackButton: true,
          tittle:
              userRole == UserRole.PATIENT ? "Caregiver Info" : "Patient Info"),
      floatingActionButton: userRole == UserRole.CAREGIVER
          ? CustomFloatingBtn(
              onPressed: () {
                CustomBottomSheet.show(
                    context: context, child: const RequestSendSheet());
              },
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Column(
        children: [
          const SizedBox(height: 16),
          Center(
            child: AnimatedToggleSwitch<int>.size(
              current: selectedIndex,
              onChanged: (value) => setState(() => selectedIndex = value),
              values: const [0, 1],
              height: 46,
              style: ToggleStyle(
                backgroundColor:
                    Theme.of(context).extension<CustomColors>()?.primarySurface,
                indicatorColor: Theme.of(context).colorScheme.primary,
                borderColor: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(8.0),
                indicatorBorderRadius: BorderRadius.circular(6.0),
              ),
              //spacing: 20.0,
              iconOpacity: 1,
              selectedIconScale: 1.0,
              indicatorSize: const Size.fromWidth(120),
              iconAnimationType: AnimationType.onHover,
              styleAnimationType: AnimationType.onHover,
              borderWidth: 5.0,
              customIconBuilder: (context, local, global) {
                final text = toggleLabels[local.index];
                return Center(
                    child: Text(text,
                        style: TextStyle(
                            height: 1,
                            letterSpacing: 0.6,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.lerp(
                                Theme.of(context).colorScheme.onSurface,
                                Theme.of(context).colorScheme.onPrimary,
                                local.animationValue))));
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
              child: selectedIndex == 0
                  ? CareRelationshipList(role: userRole!)
                  : RequestList(
                      role: userRole!,
                    )),
        ],
      ),
    );
  }
}
