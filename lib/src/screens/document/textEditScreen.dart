import 'dart:io';
import 'package:care_sync/src/component/appBar/appBar.dart';
import 'package:care_sync/src/screens/document/documentAnalyzedScreen.dart';
import 'package:flutter/material.dart';
import '../../component/btn/primaryBtn/primaryBtn.dart';
import '../../component/textField/multiLine/multiLineTextField.dart';
import '../../models/user/userSummary.dart';
import '../../service/documentPickerService.dart';

class TextEditScreen extends StatefulWidget {
  final UserSummary? patient;
  final File? imageFile;
  final DocumentData? documentData;
  final String extractText;

  const TextEditScreen({
    super.key,
    this.imageFile,
    this.documentData,
    this.patient,
    required this.extractText,
  });

  @override
  State<TextEditScreen> createState() => _TextEditScreenState();
}

class _TextEditScreenState extends State<TextEditScreen> {
  String text = '';
  bool isProcessing = true;
  bool hasError = false;
  String? errorMessage;
  String? errorTittle;

  Future<void> _confirmText(String editedText, BuildContext context) async {
    final navigator = Navigator.of(context);
    navigator.push(
      MaterialPageRoute(
        builder: (_) => DocumentAnalyzedScreen(
          imageFile: widget.imageFile,
          documentData: widget.documentData,
          extractedText: editedText,
          patient: widget.patient,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    text = widget.extractText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        tittle: "Text Preview",
        showBackButton: true,
        showProfile: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: MultiLineTextField(
                  initialText: text,
                  labelText: 'Extracted Text',
                  onChanged: (value) {
                    text = value;
                  },
                ),
              ),
            ),
            PrimaryBtn(
              label: 'Confirm',
              onPressed: () {
                _confirmText(text, context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
