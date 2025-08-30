import 'package:care_sync/src/bloc/userBloc.dart';
import 'package:care_sync/src/component/appBar/appBar.dart';
import 'package:care_sync/src/component/text/primaryText.dart';
import 'package:care_sync/src/component/text/subText.dart';
import 'package:care_sync/src/models/enums/userRole.dart';
import 'package:care_sync/src/screens/login/loginScreen.dart';
import 'package:care_sync/src/screens/profile/component/profileCard.dart';
import 'package:care_sync/src/screens/profile/component/roleBadge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/dialog/confirmDeleteDialog.dart';
import '../../component/snakbar/customSnakbar.dart';
import '../careManagement/careManagementScreen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    context.read<UserBloc>().clear();

    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _navigateToCareManagementScreen(BuildContext context) {
    final userRole = context.read<UserBloc>().state.role;

    if (userRole != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const CareManagementScreen(),
        ),
      );
    } else {
      CustomSnackbar.showCustomSnackbar(
        context: context,
        message: "Your role is not defined.",
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = context.read<UserBloc>();
    return Scaffold(
      appBar: const CustomAppBar(tittle: "Profile"),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 75,
            backgroundColor: Colors.grey,
          ),

          const SizedBox(height: 10),
          // User Info
          Column(
            children: [
              PrimaryText(text: userBloc.state.name!),
              const SizedBox(height: 5),
              SubText(text: userBloc.state.email!),
              const SizedBox(height: 5),
              RoleBadge(role: userBloc.state.role!)
            ],
          ),

          const SizedBox(height: 10),

          // Cards Section
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ProfileCard(
                  icon: Icons.person,
                  title: "Personal Information",
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                if (context.read<UserBloc>().state.role ==
                    UserRole.CAREGIVER) ...[
                  ProfileCard(
                    icon: Icons.elderly,
                    title: "Patient Info",
                    onTap: () {
                      _navigateToCareManagementScreen(context);
                    },
                  ),
                  const SizedBox(height: 12),
                ] else ...[
                  ProfileCard(
                    icon: Icons.health_and_safety,
                    title: "Medical Info",
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  ProfileCard(
                    icon: Icons.volunteer_activism,
                    title: "Caregiver Info",
                    onTap: () {
                      _navigateToCareManagementScreen(context);
                    },
                  ),
                  const SizedBox(height: 12),
                ],
                ProfileCard(
                  icon: Icons.settings,
                  title: "App Settings",
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                ProfileCard(
                  icon: Icons.logout,
                  title: "Logout",
                  onTap: () {
                    showConfirmDialog(
                      context: context,
                      title: "Confirm Logout",
                      message:
                          "Are you sure you want to log out of your account?",
                      onConfirm: () {
                        _logout(context);
                      },
                      btnLabel: "Ok",
                    );
                  },
                  showLogout: true,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
