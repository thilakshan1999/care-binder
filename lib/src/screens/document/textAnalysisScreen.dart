import 'dart:io';
import 'package:care_sync/src/service/cloudVisionService.dart';
import 'package:flutter/material.dart';

class TextAnalysisScreen extends StatefulWidget {
  final File? imageFile;

  const TextAnalysisScreen({super.key, required this.imageFile});

  @override
  State<TextAnalysisScreen> createState() => _TextAnalysisScreenState();
}

class _TextAnalysisScreenState extends State<TextAnalysisScreen> {
  String extractedText = '';
  bool isProcessing = true;

  final CloudVisionService visionService = CloudVisionService();

  @override
  void initState() {
    super.initState();
    if (widget.imageFile != null) {
      //_analyzeImage(widget.imageFile!);
    } else {
      setState(() {
        extractedText = 'No image provided.';
        isProcessing = false;
      });
    }
  }

  Future<void> _analyzeImage(File imageFile) async {
    try {
      final text = await visionService.analyzeImage(imageFile);
      setState(() {
        extractedText = text;
        isProcessing = false;
      });
    } catch (e) {
      setState(() {
        extractedText = e.toString();
        isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Text Analysis")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isProcessing
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Text(
                  extractedText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
      ),
    );
  }
}
