import 'dart:io';

import 'package:care_sync/src/bloc/userBloc.dart';
import 'package:care_sync/src/component/apiHandler/apiHandler.dart';
import 'package:care_sync/src/component/appBar/appBar.dart';
import 'package:care_sync/src/component/errorBox/ErrorBox.dart';
import 'package:care_sync/src/component/offlineComponent/offlineBanner.dart';
import 'package:care_sync/src/database/offlineDataManager.dart';
import 'package:care_sync/src/models/document/documentReference.dart';
import 'package:care_sync/src/screens/document/pdfViewerFromUrl.dart';
import 'package:care_sync/src/service/api/httpService.dart';
import 'package:care_sync/src/service/connectivityService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DocumentRefScreen extends StatefulWidget {
  final int id;
  const DocumentRefScreen({super.key, required this.id});

  @override
  State<DocumentRefScreen> createState() => _DocumentRefScreenState();
}

class _DocumentRefScreenState extends State<DocumentRefScreen> {
  bool isLoading = true;
  bool hasError = false;
  String? errorMessage;
  String? errorTittle;
  DocumentReference documentReference = sampleDocumentRef;

  late final HttpService httpService;

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      httpService = HttpService(context.read<UserBloc>());
      _fetchDocumentsRef();
      _isInitialized = true;
    }
  }

  Future<void> _fetchDocumentsRef() async {
    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = null;
      errorTittle = null;
    });

    if (connectivityService.isOnline) {
      _fetchDocumentRefApi();
    } else {
      _fetchDocumentRefLocally();
    }
  }

  //online
  Future<void> _fetchDocumentRefApi() async {
    await ApiHandler.handleApiCall<DocumentReference>(
      context: context,
      request: () => httpService.documentService.getDocumentRefById(widget.id),
      onSuccess: (data, _) {
        setState(() {
          documentReference = data;
          hasError = false;
          errorMessage = null;
          errorTittle = null;
        });
      },
      onError: (title, message) {
        setState(() {
          hasError = true;
          errorMessage = message;
          errorTittle = title;
        });
      },
      onFinally: () {
        if (mounted) {
          setState(() => isLoading = false);
        }
      },
    );
  }

  //Offline

  Future<void> _fetchDocumentRefLocally() async {
    try {
      DocumentReference? data = await OfflineDataManager.documentRepo
          .getDocumentReferenceById(widget.id);

      print("name : ");
      print(data?.fileName);
      print("type : ");
      print(data?.fileType);
      print("Url : ");
      print(data?.signedUrl);

      if (mounted) {
        setState(() {
          documentReference = data!;
          hasError = false;
          errorMessage = null;
          errorTittle = null;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          hasError = true;
          errorMessage = "$e";
          errorTittle = "Error fetching assignments locally";
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          showBackButton: true,
          tittle: "Medical Document",
        ),
        body: Column(
          children: [
            const OfflineBanner(),
            Expanded(
              child: Skeletonizer(
                enabled: isLoading,
                child: hasError
                    ? ErrorBox(
                        message: errorMessage ?? 'Something went wrong.',
                        title: errorTittle ?? 'Something went wrong.',
                        onRetry: () {
                          _fetchDocumentsRef();
                          setState(() {
                            hasError = false;
                            errorMessage = null;
                            errorTittle = null;
                          });
                        },
                      )
                    : _buildDocumentViewer(),
              ),
            )
          ],
        ));
  }

  Widget _buildDocumentViewer() {
    final isPdf = documentReference.fileType == "application/pdf";
    final url = documentReference.signedUrl;

    return isPdf
        ? PdfViewerFromUrl(url: url)
        : InteractiveViewer(
            child: connectivityService.isOnline
                ? Image.network(url, fit: BoxFit.contain,
                    loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  }, errorBuilder: (context, error, stackTrace) {
                    debugPrint(error.toString());
                    return const ErrorBox(
                      message: "Something went wrong while loading the image.",
                      title: "Failed to load image",
                    );
                  })
                : Image.file(
                    File(url),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const ErrorBox(
                        message: "Failed to load local image.",
                        title: "Error",
                      );
                    },
                  ),
          );
  }
}
