import 'package:care_sync/src/component/text/bodyText.dart';
import 'package:care_sync/src/component/text/sectionTittleText.dart';
import 'package:care_sync/src/component/text/subText.dart';
import 'package:care_sync/src/models/document/document.dart';
import 'package:care_sync/src/screens/main/mainScreen.dart';
import 'package:care_sync/src/utils/textFormatUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../bloc/userBloc.dart';
import '../../component/apiHandler/apiHandler.dart';
import '../../component/appBar/appBar.dart';
import '../../component/btn/primaryBtn/priamaryLoadingBtn.dart';
import '../../component/dialog/confirmDeleteDialog.dart';
import '../../component/errorBox/ErrorBox.dart';
import '../../component/snakbar/customSnakbar.dart';
import '../../service/api/httpService.dart';
import '../../theme/customColors.dart';
import 'component/analyzedScreen/appointmentDocument.dart';
import 'component/analyzedScreen/doctorDocument.dart';
import 'component/analyzedScreen/medDocument.dart';
import 'component/analyzedScreen/vitalDocument.dart';

class DocumentInfoScreen extends StatefulWidget {
  final int id;
  final String name;
  final bool fullAccess;

  const DocumentInfoScreen({
    super.key,
    required this.id,
    required this.name,
    required this.fullAccess,
  });

  @override
  State<DocumentInfoScreen> createState() => _DocumentInfoScreenState();
}

class _DocumentInfoScreenState extends State<DocumentInfoScreen> {
  bool isProcessing = true;
  bool isLoading = false;
  bool hasError = false;
  String? errorMessage;
  String? errorTittle;
  Document doc = sampleDocument;

  late final HttpService httpService;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      httpService = HttpService(context.read<UserBloc>());
      _fetchDocument();
      _isInitialized = true;
    }
  }

  Future<void> _fetchDocument() async {
    setState(() {
      isProcessing = true;
      hasError = false;
      errorMessage = null;
      errorTittle = null;
    });

    await ApiHandler.handleApiCall<Document>(
      context: context,
      request: () => httpService.documentService.getDocumentById(widget.id),
      onSuccess: (data, _) {
        setState(() {
          doc = data;
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
    setState(() => isLoading = true);

    await ApiHandler.handleApiCall<void>(
      context: context,
      request: () => httpService.documentService.deleteDocument(doc.id!),
      onSuccess: (_, msg) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) => const MainScreen(initialSelected: 3)),
        );
        CustomSnackbar.showCustomSnackbar(
          context: context,
          message: msg,
          backgroundColor: Theme.of(context).extension<CustomColors>()!.success,
        );
      },
      onFinally: () => setState(() => isLoading = false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          tittle: widget.name,
          showBackButton: true,
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
                          _fetchDocument();
                          setState(() {
                            hasError = false;
                            errorMessage = null;
                            errorTittle = null;
                          });
                        },
                      )
                    : SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SectionTittleText(text: "Basic Info"),
                              const SizedBox(
                                height: 10,
                              ),
                              buildInfoRow("Document Name", doc.documentName),
                              buildInfoRow("Document Type",
                                  TextFormatUtils.formatEnum(doc.documentType)),
                              buildInfoRow("Document Summary", doc.summary),
                              const SizedBox(
                                height: 10,
                              ),
                              DoctorDocument(
                                doctors: doc.doctors,
                                isEditable: false,
                              ),

                              //Med
                              MedDocument(
                                medicines: doc.medicines,
                                isEditable: false,
                              ),

                              //Appointment
                              AppointmentDocument(
                                appointments: doc.appointments,
                                isEditable: false,
                              ),

                              //Vital
                              VitalDocument(
                                vitals: doc.vitals,
                                isEditable: false,
                              ),
                              if (widget.fullAccess)
                                PrimaryLoadingBtn(
                                  label: 'Delete',
                                  loading: isLoading,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.error,
                                  onPressed: () {
                                    showConfirmDialog(
                                      context: context,
                                      title: "Delete Document",
                                      message:
                                          "Are you sure you want to delete this document?",
                                      onConfirm: () {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        _deleteDocument();
                                      },
                                    );
                                  },
                                ),
                            ]),
                      ))));
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
