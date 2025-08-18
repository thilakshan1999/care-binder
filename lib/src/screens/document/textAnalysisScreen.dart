import 'dart:io';
import 'package:care_sync/src/component/appBar/appBar.dart';
import 'package:care_sync/src/component/errorBox/ErrorBox.dart';
import 'package:care_sync/src/screens/document/component/documentLoadingIndicator.dart';
import 'package:care_sync/src/screens/document/documentAnalyzedScreen.dart';
import 'package:care_sync/src/service/api/httpService.dart';
import 'package:flutter/material.dart';
import '../../component/btn/primaryBtn/primaryBtn.dart';
import '../../component/textField/multiLine/multiLineTextField.dart';
import '../../service/documentPickerService.dart';

class TextAnalysisScreen extends StatefulWidget {
  final File? imageFile;
  final DocumentData? documentData;

  const TextAnalysisScreen({super.key, this.imageFile, this.documentData});

  @override
  State<TextAnalysisScreen> createState() => _TextAnalysisScreenState();
}

class _TextAnalysisScreenState extends State<TextAnalysisScreen> {
  String extractedText = '';
  bool isProcessing = true;
  bool hasError = false;
  String? errorMessage;
  String? errorTittle;

  final HttpService httpService = HttpService();

  @override
  void initState() {
    super.initState();
    if (widget.imageFile != null) {
      //_analyzeImage(widget.imageFile!);
    } else if (widget.documentData != null) {
      _extractText();
      // setState(() {
      //   extractedText = 'Document';
      //   isProcessing = false;
      // });
    } else {
      setState(() {
        extractedText = '';
        isProcessing = false;
        hasError = true;
        errorTittle = 'No Document Provided';
        errorMessage = 'Please select or capture a document to proceed.';
      });
    }
  }

  Future<void> _analyzeImage(File imageFile) async {
    try {
      final result =
          await httpService.visionService.extractTextFromImage(imageFile);

      setState(() {
        if (result.success) {
          extractedText = result.data ?? 'No text found.';
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

  Future<void> _extractText() async {
    try {
      final result = await httpService.documentAiService
          .extractTextFromDocument(
              widget.documentData!.file, widget.documentData!.mimeType);
      setState(() {
        if (result.success) {
          extractedText = result.data ?? 'No text found.';
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
        errorTittle = 'Failed to extract text';
        isProcessing = false;
      });
    }
  }

  Future<void> _confirmText(String extractedText, BuildContext context) async {
    final navigator = Navigator.of(context);
    navigator.push(
      MaterialPageRoute(
        builder: (_) => DocumentAnalyzedScreen(extractedText: extractedText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        tittle: isProcessing ? "Reading Document" : "Document Summary",
        showBackButton: !isProcessing,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isProcessing
            ? const DocumentLoadingIndicator(
                message: "Processing document... Please wait.",
              )
            : hasError
                ? ErrorBox(
                    message: errorMessage ?? 'Something went wrong.',
                    title: errorTittle ?? 'Something went wrong.',
                    onRetry: () {
                      setState(() {
                        isProcessing = true;
                        hasError = false;
                        errorMessage = null;
                        errorTittle = null;
                      });
                      _analyzeImage(widget.imageFile!);
                    },
                  )
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: MultiLineTextField(
                            initialText: extractedText,
                            labelText: 'Extracted Text',
                            onChanged: (value) {
                              extractedText = value;
                            },
                          ),
                        ),
                      ),
                      PrimaryBtn(
                        label: 'Confirm',
                        onPressed: () {
                          _confirmText(extractedText, context);
                        },
                      ),
                    ],
                  ),
      ),
    );
  }
}
