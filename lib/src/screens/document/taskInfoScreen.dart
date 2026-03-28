import 'package:care_sync/src/component/apiHandler/apiHandler.dart';
import 'package:care_sync/src/component/contraintBox/maxWidthConstraintBox.dart';
import 'package:care_sync/src/component/errorBox/ErrorBox.dart';
import 'package:care_sync/src/component/snakbar/customSnakbar.dart';
import 'package:care_sync/src/component/text/bodyText.dart';
import 'package:care_sync/src/component/text/sectionTittleText.dart';
import 'package:care_sync/src/component/text/subText.dart';
import 'package:care_sync/src/models/task/uploadTask.dart';
import 'package:care_sync/src/screens/document/documentScreen.dart';
import 'package:care_sync/src/screens/document/pdfViewerFromUrl.dart';
import 'package:care_sync/src/theme/customColors.dart';
import 'package:care_sync/src/utils/textFormatUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../bloc/userBloc.dart';
import '../../component/appBar/appBar.dart';
import '../../component/btn/primaryBtn/priamaryLoadingBtn.dart';
import '../../component/dialog/confirmDeleteDialog.dart';
import '../../service/api/httpService.dart';

class TaskInfoScreen extends StatefulWidget {
  final int taskId;
  final bool fullAccess;
  final int? patientId;

  const TaskInfoScreen({
    super.key,
    required this.taskId,
    required this.fullAccess,
    required this.patientId,
  });

  @override
  State<TaskInfoScreen> createState() => _TaskInfoScreenState();
}

class _TaskInfoScreenState extends State<TaskInfoScreen> {
  bool isLoadingRetry = false;
  bool isLoadingDelete = false;
  bool isProcessing = true;
  bool hasError = false;
  String? errorMessage;
  String? errorTittle;
  late final HttpService httpService;
  bool _isInitialized = false;
  UploadTask task = sampleTask;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      httpService = HttpService(context.read<UserBloc>());
      _fetchTask();
      _isInitialized = true;
    }
  }

  Future<void> _fetchTask() async {
    setState(() {
      isProcessing = true;
      hasError = false;
      errorMessage = null;
      errorTittle = null;
    });

    await ApiHandler.handleApiCall<UploadTask>(
      context: context,
      request: () => httpService.uploadTaskService
          .getTaskById(widget.taskId, widget.patientId),
      onSuccess: (data, _) {
        setState(() {
          task = data;
          hasError = false;
          errorMessage = null;
          errorTittle = null;
        });
      },
      onError: (msg, title) {
        setState(() {
          hasError = true;
          errorMessage = msg;
          errorTittle = title ?? "Request Failed";
        });
      },
      onFinally: () => setState(() => isProcessing = false),
    );
  }

  Future<void> _deleteDocument() async {
    setState(() => isLoadingDelete = true);

    await ApiHandler.handleApiCall<void>(
      context: context,
      request: () => httpService.uploadTaskService
          .deleteTask(id: task.id, patientId: widget.patientId),
      onSuccess: (_, msg) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const DocumentScreen()),
        );
        CustomSnackbar.showCustomSnackbar(
          context: context,
          message: msg,
          backgroundColor: Theme.of(context).extension<CustomColors>()!.success,
        );
      },
      onFinally: () => setState(() => isLoadingDelete = false),
    );
  }

  Future<void> _retryDocument() async {
    setState(() => isLoadingRetry = true);

    await ApiHandler.handleApiCall<void>(
      context: context,
      request: () => httpService.uploadTaskService
          .retryTask(id: task.id, patientId: widget.patientId),
      onSuccess: (_, msg) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const DocumentScreen()),
        );
        CustomSnackbar.showCustomSnackbar(
          context: context,
          message: msg,
          backgroundColor: Theme.of(context).extension<CustomColors>()!.success,
        );
      },
      onFinally: () => setState(() => isLoadingRetry = false),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPdf = task.mimeType == "application/pdf";
    final url = task.fileUrl;
    return Scaffold(
        appBar: CustomAppBar(
          tittle: "Task Info",
          showBackButton: !isLoadingDelete && !isLoadingRetry,
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Skeletonizer(
                enabled: isProcessing,
                child: hasError
                    ? ErrorBox(
                        message: errorMessage ?? 'Something went wrong.',
                        title: errorTittle ?? 'Something went wrong.',
                        onRetry: () {
                          _fetchTask();
                          setState(() {
                            hasError = false;
                            errorMessage = null;
                            errorTittle = null;
                          });
                        },
                      )
                    : SingleChildScrollView(
                        child: Center(
                        child: MaxWidthConstrainedBox(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SectionTittleText(text: "Basic Info"),
                                const SizedBox(
                                  height: 10,
                                ),
                                buildInfoRow("File Name", task.fileName),
                                buildInfoRow("Created By", task.createdBy),
                                buildInfoRow("Status Summary",
                                    TextFormatUtils.formatName(task.status)),
                                if (task.errorMessage != null)
                                  buildInfoRow("Error", task.errorMessage!),
                                const SizedBox(
                                  height: 10,
                                ),
                                const SectionTittleText(text: "Document"),
                                const SizedBox(
                                  height: 10,
                                ),
                                isPdf
                                    ? SizedBox(
                                        height: 500,
                                        child: PdfViewerFromUrl(url: url),
                                      )
                                    : InteractiveViewer(
                                        child: Image.network(url,
                                            fit: BoxFit.contain, loadingBuilder:
                                                (context, child, progress) {
                                          if (progress == null) return child;
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }, errorBuilder:
                                                (context, error, stackTrace) {
                                          debugPrint(error.toString());
                                          return const ErrorBox(
                                            message:
                                                "Something went wrong while loading the image.",
                                            title: "Failed to load image",
                                          );
                                        }),
                                      ),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (widget.fullAccess) ...[
                                  if (task.status == "FAILED") ...[
                                    PrimaryLoadingBtn(
                                      label: 'Retry',
                                      loading: isLoadingRetry,
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      onPressed: () {
                                        if (!isLoadingDelete &&
                                            !isLoadingRetry) {
                                          _retryDocument();
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                  PrimaryLoadingBtn(
                                    label: 'Delete',
                                    loading: isLoadingDelete,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.error,
                                    onPressed: () {
                                      if (!isLoadingDelete && !isLoadingRetry) {
                                        showConfirmDialog(
                                          context: context,
                                          title: "Delete Document",
                                          message:
                                              "Are you sure you want to delete this document?",
                                          onConfirm: () {
                                            _deleteDocument();
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ]
                              ]),
                        ),
                      )))));
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubText(text: label),
          const SizedBox(
            height: 4,
          ),
          BodyText(text: value),
        ],
      ),
    );
  }
}
