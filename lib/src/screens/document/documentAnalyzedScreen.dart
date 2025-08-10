import 'package:flutter/material.dart';

import '../../component/appBar/appBar.dart';
import '../../component/btn/primaryBtn/primaryBtn.dart';
import '../../component/errorBox/ErrorBox.dart';
import '../../component/textField/multiLine/multiLineTextField.dart';
import 'component/documentLoadingIndicator.dart';

class DocumentAnalyzedScreen extends StatefulWidget {
  final String extractedText;
  const DocumentAnalyzedScreen({super.key, required this.extractedText});

  @override
  State<DocumentAnalyzedScreen> createState() => _DocumentAnalyzedScreenState();
}

class _DocumentAnalyzedScreenState extends State<DocumentAnalyzedScreen> {
  bool isProcessing = true;
  bool hasError = false;
  String? errorMessage;
  String? errorTittle;

  @override
  void initState() {
    super.initState();
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
                            child: MultiLineTextField(
                              initialText: widget.extractedText,
                              labelText: 'Extracted Text',
                              onChanged: (value) {},
                            ),
                          ),
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
