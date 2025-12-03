import 'dart:io';
import 'package:care_sync/src/bloc/userBloc.dart';
import 'package:care_sync/src/component/appBar/appBar.dart';
import 'package:care_sync/src/component/errorBox/ErrorBox.dart';
import 'package:care_sync/src/lib/shareHandler.dart';
import 'package:care_sync/src/screens/document/component/documentLoadingIndicator.dart';
import 'package:care_sync/src/screens/document/documentAnalyzedScreen.dart';
import 'package:care_sync/src/service/api/httpService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import '../../component/apiHandler/apiHandler.dart';
import '../../component/btn/primaryBtn/primaryBtn.dart';
import '../../component/textField/multiLine/multiLineTextField.dart';
import '../../models/user/userSummary.dart';
import '../../service/documentPickerService.dart';

class TextAnalysisScreen extends StatefulWidget {
  final UserSummary? patient;
  final File? imageFile;
  final DocumentData? documentData;

  const TextAnalysisScreen(
      {super.key, this.imageFile, this.documentData, this.patient});

  @override
  State<TextAnalysisScreen> createState() => _TextAnalysisScreenState();
}

class _TextAnalysisScreenState extends State<TextAnalysisScreen> {
  String extractedText = '';
  bool isProcessing = true;
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
      if (widget.imageFile != null) {
        _analyzeImage(widget.imageFile!);
      } else if (widget.documentData != null) {
        _extractText();
      } else {
        setState(() {
          extractedText = '';
          isProcessing = false;
          hasError = true;
          errorTittle = 'No Document Provided';
          errorMessage = 'Please select or capture a document to proceed.';
        });
      }
      _isInitialized = true;
    }
  }

  Future<void> _analyzeImage(File imageFile) async {
    setState(() {
      isProcessing = true;
      hasError = false;
      errorMessage = null;
      errorTittle = null;
    });

    final originalMime = lookupMimeType(imageFile.path);
    print("Original file: ${imageFile.path}, MIME type: $originalMime");
  
    final uploadFile = await compressImageFile(imageFile, 75);

    final compressedMime = lookupMimeType(uploadFile.path);
    print("Compressed file: ${uploadFile.path}, MIME type: $compressedMime");

    await ApiHandler.handleApiCall<String?>(
      context: context,
      request: () => httpService.visionService.extractTextFromImage(uploadFile),
      onSuccess: (data, _) {
        setState(() {
          extractedText = data ?? 'No text found.';
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
      onFinally: () => {
        setState(() => isProcessing = false),
        ShareHandler.clearSharedFolder()
      },
    );
  }

  Future<File> compressImageFile(File imageFile, int quality) async {
    final fileSize = await imageFile.length();
    final sizeInMB = (fileSize / (1024 * 1024)).toStringAsFixed(2);
    debugPrint('📸 Image file size: $sizeInMB MB');

    try {
      final dir = await getTemporaryDirectory();
      final targetPath =
          '${dir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final XFile? compressedXFile =
          await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        targetPath,
        quality: quality,
      );

      if (compressedXFile != null) {
        final compressedFile = File(compressedXFile.path);
        final compressedSizeMB =
            (await compressedFile.length()) / (1024 * 1024);
        debugPrint(
            '🗜️ Compressed image size: ${compressedSizeMB.toStringAsFixed(2)} MB');
        return compressedFile;
      } else {
        debugPrint('⚠️ Compression failed, using original file.');
        return imageFile;
      }
    } catch (e) {
      debugPrint('⚠️ Compression error: $e');
      return imageFile;
    }
  }

  Future<void> _extractText() async {
    setState(() {
      isProcessing = true;
      hasError = false;
      errorMessage = null;
      errorTittle = null;
    });

    await ApiHandler.handleApiCall<String?>(
      context: context,
      request: () => httpService.documentAiService.extractTextFromDocument(
          widget.documentData!.file, widget.documentData!.mimeType),
      onSuccess: (data, _) {
        setState(() {
          extractedText = data ?? 'No text found.';
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
      onFinally: () => {
        setState(() => isProcessing = false),
        ShareHandler.clearSharedFolder()
      },
    );
  }

  Future<void> _confirmText(String extractedText, BuildContext context) async {
    final navigator = Navigator.of(context);
    navigator.push(
      MaterialPageRoute(
        builder: (_) => DocumentAnalyzedScreen(
          extractedText: extractedText,
          patient: widget.patient,
        ),
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
            ?  DocumentLoadingIndicator(
                message: widget.imageFile == null? "Processing document... Please wait.":" Extracting text... Please wait.",
              )
            : hasError
                ? ErrorBox(
                    message: errorMessage ?? 'Something went wrong.',
                    title: errorTittle ?? 'Something went wrong.',
                    onRetry: () {
                      if (widget.imageFile != null) {
                        _analyzeImage(widget.imageFile!);
                      } else if (widget.documentData != null) {
                        _extractText();
                      }
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
