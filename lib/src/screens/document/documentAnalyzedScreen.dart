import 'package:care_sync/src/bloc/analyzedDocumentBloc.dart';
import 'package:care_sync/src/component/btn/primaryBtn/priamaryLoadingBtn.dart';
import 'package:care_sync/src/component/dropdown/simpleEnumDropdown.dart';
import 'package:care_sync/src/component/textField/simpleTextField/simpleTextField.dart';
import 'package:care_sync/src/models/document/analyzedDocument.dart';
import 'package:care_sync/src/models/enums/documentType.dart';
import 'package:care_sync/src/screens/document/component/analyzedScreen/appointmentDocument.dart';
import 'package:care_sync/src/screens/document/component/analyzedScreen/doctorDocument.dart';
import 'package:care_sync/src/screens/document/component/analyzedScreen/medDocument.dart';
import 'package:care_sync/src/screens/document/component/analyzedScreen/vitalDocument.dart';
import 'package:care_sync/src/screens/main/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/userBloc.dart';
import '../../component/appBar/appBar.dart';
import '../../component/errorBox/ErrorBox.dart';
import '../../component/snakbar/customSnakbar.dart';
import '../../component/textField/multiLine/multiLineTextField.dart';
import '../../service/api/httpService.dart';
import '../../theme/customColors.dart';
import 'component/documentLoadingIndicator.dart';

class DocumentAnalyzedScreen extends StatefulWidget {
  final String extractedText;
  const DocumentAnalyzedScreen({super.key, required this.extractedText});

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


  @override
  void initState() {
    super.initState();
    httpService = HttpService(context.read<UserBloc>());
    _extractDocument(widget.extractedText);

    // final initialDoc = AnalyzedDocument.fromJson(sampleAnalyzedDocumentJson);
    // context.read<AnalyzedDocumentBloc>().setDocument(initialDoc);

    // setState(() {
    //   isProcessing = false;
    // });
  }

  Future<void> _extractDocument(String extractedText) async {
    try {
      final result =
          await httpService.documentService.analyzeDocument(extractedText);

      setState(() {
        if (result.success) {
          context.read<AnalyzedDocumentBloc>().setDocument(result.data!);
          hasError = false;
          errorMessage = null;
          errorTittle = null;
        } else {
          hasError = true;
          errorMessage = result.message;
          errorTittle = result.errorTittle ?? "Request Failed";
        }
        isProcessing = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = '$e';
        errorTittle = 'Unexpected Error';
        isProcessing = false;
      });
    }
  }

  Future<void> _saveDocument(AnalyzedDocument dto) async {
    final navigator = Navigator.of(context);
    final theme = Theme.of(context);

    try {
      final result = await httpService.documentService.saveDocument(dto);

      if (mounted) {
        // check if widget is still mounted
        setState(() => isLoading = false);

        if (result.success) {
          navigator.push(
            MaterialPageRoute(
              builder: (_) => const MainScreen(initialSelected: 3),
            ),
          );
          CustomSnackbar.showCustomSnackbar(
            context: context,
            message: result.message,
            backgroundColor: theme.extension<CustomColors>()!.success,
          );
        } else {
          CustomSnackbar.showCustomSnackbar(
            context: context,
            message: result.message,
            backgroundColor: theme.colorScheme.error,
          );
        }

        isLoading = false;
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        CustomSnackbar.showCustomSnackbar(
          context: context,
          message: '$e',
          backgroundColor: theme.colorScheme.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          tittle: isProcessing ? "Analyzing Document" : "Analyzed Document",
          showBackButton: !isProcessing,
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
                          setState(() {
                            isProcessing = true;
                            hasError = false;
                            errorMessage = null;
                            errorTittle = null;
                          });
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
                                        values: DocumentType.values,
                                        labelText: "Document Type",
                                        onChanged: (value) {
                                          document.documentType = value!;
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
                                print(document.toJson());
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
