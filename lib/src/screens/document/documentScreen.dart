import 'package:accordion/accordion.dart';
import 'package:care_sync/src/component/appBar/appBar.dart';
import 'package:care_sync/src/component/btn/floatingBtn/floatingBtn.dart';
import 'package:care_sync/src/component/text/bodyText.dart';
import 'package:care_sync/src/component/text/primaryText.dart';
import 'package:care_sync/src/screens/document/component/uploadOptionSheet.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../component/bottomSheet/bottomSheet.dart';
import '../../component/errorBox/ErrorBox.dart';
import '../../models/documentSummary.dart';
import '../../service/api/httpService.dart';
import '../../theme/customColors.dart';
import 'component/documentCard.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  bool isLoading = true;
  bool hasError = false;
  String? errorMessage;
  String? errorTittle;
  late List<DocumentSummary> documentList;

  final HttpService httpService = HttpService();

  @override
  void initState() {
    super.initState();
    _fetchAllDocumentsSummary();
  }

  Future<void> _fetchAllDocumentsSummary() async {
    try {
      final result = await httpService.documentService.getAllDocumentsSummary();
      if (!mounted) return;
      setState(() {
        if (result.success) {
          documentList = result.data!;
          hasError = false;
          errorMessage = null;
          errorTittle = null;
        } else {
          hasError = true;
          errorMessage = result.message;
          errorTittle = result.errorTittle ?? "Request Failed";
        }
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        hasError = true;
        errorMessage = '$e';
        errorTittle = 'Unexpected Error';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        tittle: "Medical Document",
      ),
      floatingActionButton: CustomFloatingBtn(
        onPressed: () {
          CustomBottomSheet.show(
              context: context, child: const UploadOptionSheet());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Skeletonizer(
        enabled: isLoading,
        child: hasError
            ? ErrorBox(
                message: errorMessage ?? 'Something went wrong.',
                title: errorTittle ?? 'Something went wrong.',
                onRetry: () {
                  setState(() {
                    isLoading = true;
                    hasError = false;
                    errorMessage = null;
                    errorTittle = null;
                  });
                },
              )
            : (isLoading == false && documentList.isEmpty)
                ? const Center(
                    child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: BodyText(
                      text: 'No documents found yet.',
                      textAlign: TextAlign.center,
                    ),
                  ))
                : Accordion(
                    maxOpenSections: 1,
                    headerBackgroundColor: Theme.of(context)
                        .extension<CustomColors>()
                        ?.primarySurface,
                    headerBackgroundColorOpened: Colors.blue.shade50,
                    headerBorderColor: Colors.blue.shade50,
                    headerBorderWidth: 1,
                    paddingListTop: 16,
                    paddingListBottom: 16,
                    paddingListHorizontal: 12,
                    children: isLoading
                        ? mockDocumentSummaries.map((doc) {
                            return documentCard(
                              context: context,
                              id: doc.id,
                              name: doc.documentName,
                              updatedTime: doc.updatedTime,
                              summary: doc.summary,
                              type: doc.documentType,
                            );
                          }).toList()
                        : documentList.map((doc) {
                            return documentCard(
                              context: context,
                              id: doc.id,
                              name: doc.documentName,
                              updatedTime: doc.updatedTime,
                              summary: doc.summary,
                              type: doc.documentType,
                            );
                          }).toList(),
                  ),
      ),
    );
  }
}
