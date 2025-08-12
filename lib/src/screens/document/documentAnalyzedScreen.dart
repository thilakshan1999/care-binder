import 'package:care_sync/src/component/dropdown/simpleDropdown.dart';
import 'package:care_sync/src/component/textField/simpleTextField/simpleTextField.dart';
import 'package:care_sync/src/models/analyzedDocument.dart';
import 'package:care_sync/src/models/enums/documentType.dart';
import 'package:flutter/material.dart';

import '../../component/appBar/appBar.dart';
import '../../component/btn/primaryBtn/primaryBtn.dart';
import '../../component/errorBox/ErrorBox.dart';
import '../../component/textField/multiLine/multiLineTextField.dart';
import '../../service/api/httpService.dart';
import 'component/documentLoadingIndicator.dart';

class DocumentAnalyzedScreen extends StatefulWidget {
  final String extractedText;
  const DocumentAnalyzedScreen({super.key, required this.extractedText});

  @override
  State<DocumentAnalyzedScreen> createState() => _DocumentAnalyzedScreenState();
}

class _DocumentAnalyzedScreenState extends State<DocumentAnalyzedScreen> {
  late AnalyzedDocument document;
  bool isProcessing = true;
  bool hasError = false;
  String? errorMessage;
  String? errorTittle;

  final HttpService httpService = HttpService();

  @override
  void initState() {
    super.initState();
    //_extractDocument(widget.extractedText);
    setState(() {
      document = sampleAnalyzedDocument;
      isProcessing = false;
    });
  }

  Future<void> _extractDocument(String extractedText) async {
    try {
      final result =
          await httpService.documentService.analyzeDocument(extractedText);

      setState(() {
        if (result.success) {
          document = result.data!;
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
                  : Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(vertical: 16),
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
                                  SimpleDropdownField<DocumentType>(
                                    initialValue: document.documentType,
                                    values: DocumentType.values,
                                    labelText: "Document Type",
                                    onChanged: (value) {
                                      document.documentType = value;
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
                                ],
                              )),
                        ),
                        PrimaryBtn(
                          label: 'Save',
                          onPressed: () {
                            debugPrint("Save Text");
                          },
                        ),
                      ],
                    )),
    );
  }
}
