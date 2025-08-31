import 'package:accordion/accordion.dart';
import 'package:care_sync/src/bloc/userBloc.dart';
import 'package:care_sync/src/component/appBar/appBar.dart';
import 'package:care_sync/src/component/btn/floatingBtn/floatingBtn.dart';
import 'package:care_sync/src/component/text/bodyText.dart';
import 'package:care_sync/src/models/enums/careGiverPermission.dart';
import 'package:care_sync/src/models/enums/documentType.dart';
import 'package:care_sync/src/models/user/userSummary.dart';
import 'package:care_sync/src/screens/document/component/uploadOptionSheet.dart';
import 'package:care_sync/src/utils/textFormatUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../component/apiHandler/apiHandler.dart';
import '../../component/bottomSheet/bottomSheet.dart';
import '../../component/errorBox/ErrorBox.dart';
import '../../component/filterBar/filterBar.dart';
import '../../models/document/documentSummary.dart';
import '../../service/api/httpService.dart';
import '../../theme/customColors.dart';
import 'component/documentCard.dart';

class DocumentListScreen extends StatefulWidget {
  final UserSummary? patient;
  final CareGiverPermission? permission;
  const DocumentListScreen({super.key, this.patient, this.permission});

  @override
  State<DocumentListScreen> createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen> {
  bool isLoading = true;
  bool hasError = false;
  String? errorMessage;
  String? errorTittle;
  List<DocumentSummary> documentList = mockDocumentSummaries;
  List<String> categories =
      TextFormatUtils.enumListToStringList(DocumentType.values);
  int selectedIndex = 0;

  late final HttpService httpService;

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      httpService = HttpService(context.read<UserBloc>());
      _fetchAllDocumentsSummary(null);
      _isInitialized = true;
    }
  }

  Future<void> _fetchAllDocumentsSummary(String? type) async {
    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = null;
      errorTittle = null;
    });
    await ApiHandler.handleApiCall<List<DocumentSummary>>(
      context: context,
      request: () => httpService.documentService
          .getAllDocumentsSummary(type: type, patientId: widget.patient?.id),
      onSuccess: (data, _) {
        setState(() {
          documentList = data;
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

  @override
  Widget build(BuildContext context) {
    bool fullAccess = widget.permission != null
        ? widget.permission == CareGiverPermission.VIEW_ONLY
            ? false
            : true
        : true;
    return Scaffold(
      appBar: CustomAppBar(
        showBackButton: widget.patient != null,
        tittle: widget.patient != null
            ? "${TextFormatUtils.formatName(widget.patient!.name)} Doc"
            : "Medical Document",
      ),
      floatingActionButton: fullAccess
          ? CustomFloatingBtn(
              onPressed: () {
                CustomBottomSheet.show(
                    context: context,
                    child: UploadOptionSheet(patient: widget.patient));
              },
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Skeletonizer(
        enabled: isLoading,
        child: hasError
            ? ErrorBox(
                message: errorMessage ?? 'Something went wrong.',
                title: errorTittle ?? 'Something went wrong.',
                onRetry: () {
                  _fetchAllDocumentsSummary(categories[selectedIndex]);
                  setState(() {
                    hasError = false;
                    errorMessage = null;
                    errorTittle = null;
                  });
                },
              )
            : Column(
                children: [
                  DocumentFilterBar(
                    categories: categories,
                    selectedIndex: selectedIndex,
                    onChanged: (value) {
                      _fetchAllDocumentsSummary(categories[value]);
                      setState(() {
                        selectedIndex = value;
                        isLoading = true;
                        hasError = false;
                        errorMessage = null;
                        errorTittle = null;
                      });
                    },
                  ),
                  (isLoading == false && documentList.isEmpty)
                      ? const Expanded(
                          child: Center(
                              child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: BodyText(
                            text: 'No documents found yet.',
                            textAlign: TextAlign.center,
                          ),
                        )))
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
                          children: documentList.map((doc) {
                            return documentCard(
                                context: context,
                                id: doc.id,
                                name: doc.documentName,
                                updatedTime: doc.updatedTime,
                                summary: doc.summary,
                                type: doc.documentType,
                                fullAccess: fullAccess);
                          }).toList(),
                        ),
                ],
              ),
      ),
    );
  }
}
