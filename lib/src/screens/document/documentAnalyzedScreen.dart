import 'dart:io';

import 'package:care_sync/src/bloc/analyzedDocumentBloc.dart';
import 'package:care_sync/src/component/btn/primaryBtn/priamaryLoadingBtn.dart';
import 'package:care_sync/src/component/datePicker/dateTimePickerField.dart';
import 'package:care_sync/src/component/dropdown/simpleEnumDropdown.dart';
import 'package:care_sync/src/component/textField/simpleTextField/simpleTextField.dart';
import 'package:care_sync/src/models/document/analyzedDocument.dart';
import 'package:care_sync/src/models/enums/documentType.dart';
import 'package:care_sync/src/screens/document/component/analyzedScreen/appointmentDocument.dart';
import 'package:care_sync/src/screens/document/component/analyzedScreen/doctorDocument.dart';
import 'package:care_sync/src/screens/document/component/analyzedScreen/medDocument.dart';
import 'package:care_sync/src/screens/document/component/analyzedScreen/vitalDocument.dart';
import 'package:care_sync/src/screens/document/documentScreen.dart';
import 'package:care_sync/src/service/documentPickerService.dart';
import 'package:care_sync/src/utils/shareHandler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/userBloc.dart';
import '../../component/apiHandler/apiHandler.dart';
import '../../component/appBar/appBar.dart';
import '../../component/errorBox/ErrorBox.dart';
import '../../component/snakbar/customSnakbar.dart';
import '../../component/textField/multiLine/multiLineTextField.dart';
import '../../models/user/userSummary.dart';
import '../../service/api/httpService.dart';
import '../../theme/customColors.dart';
import 'component/documentLoadingIndicator.dart';

class DocumentAnalyzedScreen extends StatefulWidget {
  final UserSummary? patient;
  final String extractedText;
  final File? imageFile;
  final DocumentData? documentData;
  const DocumentAnalyzedScreen(
      {super.key,
      required this.extractedText,
      this.patient,
      this.imageFile,
      this.documentData});

  @override
  State<DocumentAnalyzedScreen> createState() => _DocumentAnalyzedScreenState();
}

class _DocumentAnalyzedScreenState extends State<DocumentAnalyzedScreen> {
  bool isProcessing = true;
  bool isLoading = false;
  bool hasError = false;
  String? errorMessage;
  String? errorTittle;

  late final HttpService httpService;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      httpService = HttpService(context.read<UserBloc>());
      _extractDocument(widget.extractedText);

      // final initialDoc = AnalyzedDocument.fromJson(sampleAnalyzedDocumentJson);
      // context.read<AnalyzedDocumentBloc>().setDocument(initialDoc);

      // setState(() {
      //   isProcessing = false;
      // });
      _isInitialized = true;
    }
  }

  Future<void> _extractDocument(String extractedText) async {
    setState(() {
      isProcessing = true;
      hasError = false;
      errorMessage = null;
      errorTittle = null;
    });

    await ApiHandler.handleApiCall<AnalyzedDocument>(
      context: context,
      request: () => httpService.documentService
          .analyzeDocument(extractedText, widget.patient?.id),
      onSuccess: (data, msg) {
        setState(() {
          context.read<AnalyzedDocumentBloc>().setDocument(data);
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

  Future<void> _saveDocument(AnalyzedDocument dto) async {
    setState(() => isLoading = true);

    File? fileToSend;
    if (widget.imageFile != null) {
      fileToSend = widget.imageFile!;
    } else if (widget.documentData?.file != null) {
      fileToSend = widget.documentData!.file;
    }

    await ApiHandler.handleApiCall<void>(
      context: context,
      request: () => httpService.documentService.saveDocument(
          dto,
          widget.patient?.id,
          fileToSend!,
          context.read<UserBloc>().state.accessToken!),
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
      onFinally: () {
        setState(() => isLoading = false);
        ShareHandler.clearSharedFolder();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          tittle: isProcessing ? "Analyzing Document" : "Analyzed Document",
          showBackButton: !isProcessing,
          onBackPressed: () => {
            context.read<AnalyzedDocumentBloc>().clear(),
            Navigator.pop(context)
          },
        ),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: isProcessing
                ? const DocumentLoadingIndicator(
                    message: "Analyzing document... Please wait.",
                  )
                : hasError
                    ? ErrorBox(
                        message: errorMessage ?? 'Something went wrong.',
                        title: errorTittle ?? 'Something went wrong.',
                        onRetry: () {
                          _extractDocument(widget.extractedText);
                        },
                      )
                    : BlocBuilder<AnalyzedDocumentBloc, AnalyzedDocument?>(
                        builder: (context, document) {
                        if (document == null) {
                          return const DocumentLoadingIndicator(
                            message: "Loading document...",
                          );
                        }

                        return Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Column(
                                    children: [
                                      SimpleTextField(
                                        initialText: document.documentName,
                                        labelText: 'Document Name',
                                        onChanged: (value) {
                                          document.documentName = value;
                                        },
                                      ),

                                      const SizedBox(
                                        height: 20,
                                      ),

                                      SimpleEnumDropdownField<DocumentType>(
                                        initialValue: document.documentType,
                                        values: document.documentTypeList,
                                        labelText: "Document Type",
                                        onChanged: (value) {
                                          document.documentType = value!;
                                        },
                                      ),

                                      const SizedBox(
                                        height: 20,
                                      ),

                                      DateTimePickerField(
                                        labelText: "Test Date",
                                        initialDateTime: document.dateOfTest,
                                        showTime: true,
                                        allowClear: true,
                                        onChanged: (dateTime) {
                                          setState(() {
                                            document.dateOfTest = dateTime;
                                          });
                                        },
                                      ),

                                      const SizedBox(
                                        height: 20,
                                      ),

                                      DateTimePickerField(
                                        labelText: "Visit Date",
                                        initialDateTime: document.dateOfVisit,
                                        showTime: true,
                                        allowClear: true,
                                        onChanged: (dateTime) {
                                          setState(() {
                                            document.dateOfVisit = dateTime;
                                          });
                                        },
                                      ),

                                      const SizedBox(
                                        height: 20,
                                      ),

                                      MultiLineTextField(
                                        initialText: document.summary,
                                        labelText: 'Summary',
                                        onChanged: (value) {
                                          document.summary = value;
                                        },
                                      ),

                                      const SizedBox(
                                        height: 20,
                                      ),

                                      //Doctor
                                      DoctorDocument(
                                          doctorsWithStatus: document.doctors),

                                      //Med
                                      MedDocument(
                                          medicinesWithStatus:
                                              document.medicines),

                                      //Appointment
                                      AppointmentDocument(
                                          appointmentsWithStatus:
                                              document.appointments),

                                      //Vital
                                      VitalDocument(
                                          vitalsWithStatus: document.vitals)
                                    ],
                                  )),
                            ),
                            PrimaryLoadingBtn(
                              label: 'Save',
                              loading: isLoading,
                              onPressed: () {
                                setState(() {
                                  isLoading = true;
                                });
                                _saveDocument(document);
                              },
                            ),
                          ],
                        );
                      })));
  }
}
