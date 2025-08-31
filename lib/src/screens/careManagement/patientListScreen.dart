import 'package:care_sync/src/bloc/userBloc.dart';
import 'package:care_sync/src/component/appBar/appBar.dart';
import 'package:care_sync/src/models/user/userSummary.dart';
import 'package:care_sync/src/screens/careManagement/component/patientCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../component/apiHandler/apiHandler.dart';
import '../../component/errorBox/ErrorBox.dart';
import '../../component/text/bodyText.dart';
import '../../models/enums/careGiverPermission.dart';
import '../../models/user/careGiverAssignment.dart';
import '../../service/api/httpService.dart';

class PatientListScreen extends StatefulWidget {
  final String tittle;
  final Function(UserSummary, CareGiverPermission) onTap;
  const PatientListScreen({
    super.key,
    required this.tittle,
    required this.onTap,
  });

  @override
  State<PatientListScreen> createState() => _PatientListState();
}

class _PatientListState extends State<PatientListScreen> {
  bool isLoading = true;
  bool hasError = false;
  String? errorMessage;
  String? errorTittle;

  List<CareGiverAssignment> members = dummyCareGiverAssignments;
  late final HttpService httpService;
  bool _isInitialized = false;

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
    await ApiHandler.handleApiCall<List<CareGiverAssignment>>(
      context: context,
      request: () =>
          httpService.careGiverAssignmentService.getPatientsOfCaregiver(),
      onSuccess: (data, _) {
        setState(() {
          members = data;
          hasError = false;
          errorMessage = null;
          errorTittle = null;
        });
      },
      onError: (title, message) {
        setState(() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(tittle: widget.tittle),
      body: Padding(
          padding: const EdgeInsets.all(16),
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
                          text: 'No patients found yet.',
                          textAlign: TextAlign.center,
                        ),
                      ))
                    : ListView.builder(
                        itemCount: members.length,
                        itemBuilder: (context, index) {
                          final member = members[index];
                          return PatientCard(
                              member: member,
                              onTap: () {
                                widget.onTap(member.patient, member.permission);
                              });
                        },
                      ),
          )),
    );
  }
}
