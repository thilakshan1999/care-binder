import 'package:care_sync/src/bloc/userBloc.dart';
import 'package:care_sync/src/component/apiHandler/apiHandler.dart';
import 'package:care_sync/src/component/appBar/appBar.dart';
import 'package:care_sync/src/component/dropdown/simpleObjeckDropdown.dart';
import 'package:care_sync/src/component/errorBox/ErrorBox.dart';
import 'package:care_sync/src/component/text/bodyText.dart';
import 'package:care_sync/src/database/offlineDataManager.dart';
import 'package:care_sync/src/models/enums/userRole.dart';
import 'package:care_sync/src/models/task/uploadTask.dart';
import 'package:care_sync/src/models/user/careGiverAssignment.dart';
import 'package:care_sync/src/screens/task/component/taskCard.dart';
import 'package:care_sync/src/service/api/httpService.dart';
import 'package:care_sync/src/service/connectivityService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<TaskListScreen> {
  bool isLoading = true;
  bool hasError = false;
  String? errorMessage;
  String? errorTittle;
  List<UploadTask> taskList = [];
  late final HttpService httpService;
  bool _isInitialized = false;
  List<CareGiverAssignment> members = [];
  bool isCaregiver = false;
  int? patientId;

  @override
  void initState() {
    super.initState();
    connectivityService.addListener(_onConnectivityChange);
  }

  @override
  void dispose() {
    connectivityService.removeListener(_onConnectivityChange);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      httpService = HttpService(context.read<UserBloc>());
      isCaregiver = context.read<UserBloc>().state.role == UserRole.CAREGIVER;
      _fetchUploadTask();
      _isInitialized = true;
    }
  }

  void _onConnectivityChange() {
    if (mounted) {
      _fetchUploadTask();
      setState(() {});
    }
  }

  Future<void> _fetchUploadTask() async {
    if (isCaregiver) {
      if (patientId == null) {
        _fetchAssignmentsLocally(context.read<UserBloc>().state.email!);
      } else {
        _fetchUploadTaskApi(patientId);
      }
    } else {
      _fetchUploadTaskApi(null);
    }
  }

  Future<void> _fetchAssignmentsLocally(String email) async {
    try {
      List<CareGiverAssignment> data =
          await OfflineDataManager.userRepo.getPatientsByCaregiverEmail(email);

      if (mounted) {
        setState(() {
          members = data;
          hasError = false;
          errorMessage = null;
          errorTittle = null;
        });
        if (members.isNotEmpty) {
          _fetchUploadTaskApi(members[0].patient.id);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          members = [];
          hasError = true;
          errorMessage = "$e";
          errorTittle = "Error fetching patients";
          isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchUploadTaskApi(int? patientId) async {
    await ApiHandler.handleApiCall<List<UploadTask>>(
      context: context,
      request: () => httpService.uploadTaskService.getUserTasks(
        patientId: patientId,
      ),
      onSuccess: (data, _) {
        setState(() {
          taskList = data;
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
    bool fullAccess = true;
    return Scaffold(
      appBar: const CustomAppBar(
        showBackButton: true,
        showProfile: true,
        tittle: "Task Status",
      ),
      body: Skeletonizer(
          enabled: isLoading,
          child: hasError
              ? ErrorBox(
                  message: errorMessage ?? 'Something went wrong.',
                  title: errorTittle ?? 'Something went wrong.',
                  onRetry: () {
                    _fetchUploadTask();
                    setState(() {
                      hasError = false;
                      errorMessage = null;
                      errorTittle = null;
                    });
                  },
                )
              : Column(
                  children: [
                    if (isCaregiver)
                      Padding(
                        padding: const EdgeInsetsGeometry.symmetric(
                            horizontal: 12, vertical: 20),
                        child: SimpleObjectDropdownField<CareGiverAssignment>(
                          labelText: "Patients",
                          initialValue: members.isNotEmpty ? members[0] : null,
                          values: members,
                          displayText: (assignment) => assignment.patient.name,
                          onChanged: (assignment) {
                            setState(() {
                              patientId = assignment?.patient.id;
                            });
                            _fetchUploadTaskApi(patientId);
                          },
                        ),
                      ),
                    Expanded(
                        child: (isLoading == false && taskList.isEmpty)
                            ? const Center(
                                child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: BodyText(
                                  text: 'No active tasks at the moment.',
                                  textAlign: TextAlign.center,
                                ),
                              ))
                            : SingleChildScrollView(
                                padding:
                                    const EdgeInsets.only(bottom: 80, top: 10),
                                child: Column(
                                  children: [
                                    if (taskList.isNotEmpty)
                                      ...taskList.map((task) => TaskCard(
                                            task: task,
                                            context: context,
                                            fullAccess: fullAccess,
                                            patientId: null,
                                          )),
                                  ],
                                )))
                  ],
                )),
    );
  }
}
