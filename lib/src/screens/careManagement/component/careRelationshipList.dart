import 'package:care_sync/src/bloc/userBloc.dart';
import 'package:care_sync/src/database/app_database.dart';
import 'package:care_sync/src/database/repository/user_repository.dart';
import 'package:care_sync/src/models/enums/userRole.dart';
import 'package:care_sync/src/models/user/careGiverAssignment.dart';
import 'package:care_sync/src/screens/careManagement/component/accessUpdateSheet.dart';
import 'package:care_sync/src/screens/careManagement/component/careRelationshipCard.dart';
import 'package:care_sync/src/service/connectivityService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../component/apiHandler/apiHandler.dart';
import '../../../component/bottomSheet/bottomSheet.dart';
import '../../../component/dialog/confirmDeleteDialog.dart';
import '../../../component/errorBox/ErrorBox.dart';
import '../../../component/snakbar/customSnakbar.dart';
import '../../../component/text/bodyText.dart';
import '../../../models/enums/careGiverPermission.dart';
import '../../../service/api/httpService.dart';
import '../../../theme/customColors.dart';

class CareRelationshipList extends StatefulWidget {
  final UserRole role;
  const CareRelationshipList({super.key, required this.role});

  @override
  State<CareRelationshipList> createState() => _CareRelationshipListState();
}

class _CareRelationshipListState extends State<CareRelationshipList> {
  late final AppDatabase _db;
  late final UserRepository _userRepo;

  bool isLoading = true;
  bool hasError = false;
  String? errorMessage;
  String? errorTittle;

  List<CareGiverAssignment> members = dummyCareGiverAssignments;
  late final HttpService httpService;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _userRepo = UserRepository(_db);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      httpService = HttpService(context.read<UserBloc>());
      _fetchUserList();
      _isInitialized = true;
    }
  }

  Future<void> _fetchUserList() async {
    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = null;
      errorTittle = null;
    });

    if (connectivityService.isOnline) {
      _fetchUserListApi();
    } else {
      _fetchAssignmentsLocally(context.read<UserBloc>().state.email!);
    }
  }

  Future<void> _deleteUser(int assignmentId) async {
    setState(() => isLoading = true);

    await ApiHandler.handleApiCall<void>(
      context: context,
      request: () =>
          httpService.careGiverAssignmentService.removeAssignment(assignmentId),
      onSuccess: (_, msg) {
        CustomSnackbar.showCustomSnackbar(
          context: context,
          message: msg,
          backgroundColor: Theme.of(context).extension<CustomColors>()!.success,
        );
        _fetchUserList();
      },
      onError: (message, title) => {
        setState(() => isLoading = false),
        CustomSnackbar.showCustomSnackbar(
          context: context,
          message: message,
          backgroundColor: Theme.of(context).colorScheme.error,
        )
      },
    );
  }

  Future<void> _updatePermission(int id, CareGiverPermission permission) async {
    setState(() => isLoading = true);

    await ApiHandler.handleApiCall<void>(
      context: context,
      request: () => httpService.careGiverAssignmentService
          .updatePermission(id, permission.toJson()),
      onSuccess: (_, msg) {
        CustomSnackbar.showCustomSnackbar(
          context: context,
          message: msg,
          backgroundColor: Theme.of(context).extension<CustomColors>()!.success,
        );
        Navigator.of(context).pop(true);
        _fetchUserList();
      },
    );
  }

  //Online
  Future<void> _fetchUserListApi() async {
    await ApiHandler.handleApiCall<List<CareGiverAssignment>>(
      context: context,
      request: () => widget.role == UserRole.CAREGIVER
          ? httpService.careGiverAssignmentService.getPatientsOfCaregiver()
          : httpService.careGiverAssignmentService.getCaregiversOfPatient(),
      onSuccess: (data, _) {
        setState(() {
          members = data;
          hasError = false;
          errorMessage = null;
          errorTittle = null;
        });
        _saveAssignmentsLocally(data);
      },
      onError: (title, message) {
        setState(() {
          members = [];
          hasError = true;
          errorMessage = message;
          errorTittle = title;
        });
      },
      onFinally: () {
        if (mounted) {
          setState(() => isLoading = false);
        }
      },
    );
  }

  // Offline
  Future<void> _saveAssignmentsLocally(
      List<CareGiverAssignment> assignments) async {
    try {
      await _userRepo.saveCaregiverAssignments(assignments);
    } catch (e) {
      print("Error saving assignments locally: $e");
    }
  }

  Future<void> _fetchAssignmentsLocally(String email) async {
    try {
      List<CareGiverAssignment> data;

      if (widget.role == UserRole.PATIENT) {
        data = await _userRepo.getCaregiversByPatientEmail(email);
      } else {
        data = await _userRepo.getPatientsByCaregiverEmail(email);
      }
      // Update UI
      if (mounted) {
        setState(() {
          members = data;
          hasError = false;
          errorMessage = null;
          errorTittle = null;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          members = [];
          hasError = true;
          errorMessage = "$e";
          errorTittle = "Error fetching assignments locally";
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Skeletonizer(
          enabled: isLoading,
          child: hasError
              ? ErrorBox(
                  message: errorMessage ?? 'Something went wrong.',
                  title: errorTittle ?? 'Something went wrong.',
                  onRetry: () {
                    _fetchUserList();
                    setState(() {
                      hasError = false;
                      errorMessage = null;
                      errorTittle = null;
                    });
                  },
                )
              : (isLoading == false && members.isEmpty)
                  ? const Center(
                      child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: BodyText(
                        text: 'No members found yet.',
                        textAlign: TextAlign.center,
                      ),
                    ))
                  : ListView.builder(
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        final member = members[index];
                        return CareRelationshipCard(
                          member: member,
                          role: widget.role,
                          onDelete: () {
                            showConfirmDialog(
                                context: context,
                                title: "Remove Member",
                                message:
                                    "Are you sure you want to remove this member?",
                                onConfirm: () {
                                  _deleteUser(member.id);
                                });
                          },
                          onUpdate: () {
                            CustomBottomSheet.show(
                                context: context,
                                child: AccessUpdateSheet(
                                  member: member,
                                  onUpdate: (permission) {
                                    _updatePermission(member.id, permission);
                                  },
                                ));
                          },
                        );
                      },
                    ),
        ));
  }
}
