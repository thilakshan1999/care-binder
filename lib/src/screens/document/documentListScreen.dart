import 'dart:io';

import 'package:accordion/accordion.dart';
import 'package:care_sync/src/bloc/userBloc.dart';
import 'package:care_sync/src/component/appBar/appBar.dart';
import 'package:care_sync/src/component/btn/floatingBtn/floatingBtn.dart';
import 'package:care_sync/src/component/contraintBox/maxWidthConstraintBox.dart';
import 'package:care_sync/src/component/dialog/confirmDeleteDialog.dart';
import 'package:care_sync/src/component/dialog/guidelineDialog.dart';
import 'package:care_sync/src/component/filterIcon/filterIcon.dart';
import 'package:care_sync/src/component/offlineComponent/offlineBanner.dart';
import 'package:care_sync/src/component/snakbar/customSnakbar.dart';
import 'package:care_sync/src/component/text/bodyText.dart';
import 'package:care_sync/src/models/document/documentReference.dart';
import 'package:care_sync/src/models/enums/careGiverPermission.dart';
import 'package:care_sync/src/models/enums/documentFilterOption.dart';
import 'package:care_sync/src/models/enums/documentType.dart';
import 'package:care_sync/src/models/user/userSummary.dart';
import 'package:care_sync/src/screens/document/component/documentFilterSheet.dart';
import 'package:care_sync/src/screens/document/component/uploadOptionSheet.dart';
import 'package:care_sync/src/screens/document/component/selectionBottomBar.dart';
import 'package:care_sync/src/utils/textFormatUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
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
  bool isLoadShare = false;
  bool hasError = false;
  String? errorMessage;
  String? errorTittle;
  List<DocumentSummary> documentList = mockDocumentSummaries;
  List<String> categories =
      TextFormatUtils.enumListToStringList(DocumentType.values);
  int selectedIndex = 0;
  DocumentFilterOption filterOption = DocumentFilterOption.UPLOAD_TIME;
  SortOrder sortOrder = SortOrder.DESCENDING;
  late final HttpService httpService;
  bool _isInitialized = false;
  bool selectedMode = false;
  List<int> selectedIds = [];

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
      request: () => httpService.documentService.getAllDocumentsSummary(
          type: type,
          patientId: widget.patient?.id,
          filterBy: filterOption.name,
          sortOrder: sortOrder.name),
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

  Future<void> _fetchDocumentReference() async {
    setState(() => isLoadShare = true);

    await ApiHandler.handleApiCall<List<DocumentReference>>(
        context: context,
        request: () =>
            httpService.documentService.getDocumentsFileUrls(selectedIds),
        onSuccess: (data, _) async {
          try {
            // Create a temporary directory to store downloaded files
            final directory = await getTemporaryDirectory();
            final List<XFile> sharedFiles = [];

            for (final doc in data) {
              final filePath = '${directory.path}/${doc.fileName}';
              final file = File(filePath);

              // Download file from signed URL
              final response = await http.get(Uri.parse(doc.signedUrl));
              if (response.statusCode == 200) {
                await file.writeAsBytes(response.bodyBytes);
                sharedFiles.add(XFile(filePath));
              } else {
                debugPrint('Failed to download ${doc.fileName}');
              }
            }

            // Share all downloaded files
            final params = ShareParams(
              files: sharedFiles,
              text:
                  'Shared medical records for ${widget.patient?.name ?? context.read<UserBloc>().state.name ?? 'Patient'} via CareBinder.',
            );

            try {
              setState(() {
                isLoadShare = false;
              });
              await SharePlus.instance.share(params);
            } finally {
              setState(() {
                selectedMode = false;
                selectedIds.clear();
              });

              // Clean up temporary files after sharing
              for (final file in sharedFiles) {
                final tempFile = File(file.path);
                if (await tempFile.exists()) {
                  await tempFile.delete();
                  print('Deleted temp file: ${tempFile.path}');
                }
              }
            }
          } catch (e) {
            setState(() => isLoadShare = false);
            debugPrint('Error sharing files: $e');
            CustomSnackbar.showCustomSnackbar(
              context: context,
              message: 'Failed to share documents.',
              backgroundColor: Theme.of(context).colorScheme.error,
            );
          }
        },
        onError: (message, title) {
          setState(() => isLoadShare = false);
          CustomSnackbar.showCustomSnackbar(
            context: context,
            message: message,
            backgroundColor: Theme.of(context).colorScheme.error,
          );
        });
  }

  Future<void> _deleteDocuments() async {
    setState(() => isLoading = true);

    await ApiHandler.handleApiCall<void>(
        context: context,
        request: () =>
            httpService.documentService.deleteMultipleDocuments(selectedIds),
        onSuccess: (_, msg) {
          _fetchAllDocumentsSummary(categories[selectedIndex]);
          CustomSnackbar.showCustomSnackbar(
            context: context,
            message: msg,
            backgroundColor:
                Theme.of(context).extension<CustomColors>()!.success,
          );
        },
        onError: (message, title) => {
              setState(() => isLoading = false),
              CustomSnackbar.showCustomSnackbar(
                context: context,
                message: message,
                backgroundColor: Theme.of(context).colorScheme.error,
              )
            },
        onFinally: () {
          setState(() {
            selectedMode = false;
            selectedIds.clear();
          });
        });
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
          showProfile: !selectedMode,
          tittle: widget.patient != null
              ? "${TextFormatUtils.formatName(widget.patient!.name)} Doc"
              : "Medical Document",
          customActions: [
            IconButton(
              icon: Icon(Icons.info_outline,
                  color: Theme.of(context).colorScheme.surface),
              onPressed: () {
                GuidelineDialog.show(
                  context,
                  title: "How to Select Documents",
                  instructions: [
                    "Use long press on any document to enable selection mode.",
                    "In selection mode, you can share selected documents using the Share icon at the bottom left corner.",
                    "Delete selected documents using the Delete icon at the bottom right corner.",
                    "Return to normal mode by tapping the Close icon at the top right corner.",
                  ],
                );
              },
            ),
            if (selectedMode)
              IconButton(
                icon: Icon(Icons.close,
                    color: Theme.of(context).colorScheme.surface),
                onPressed: () {
                  setState(() {
                    selectedMode = false;
                    selectedIds.clear();
                  });
                },
              ),
          ],
        ),
        floatingActionButton: fullAccess
            ? !selectedMode
                ? CustomFloatingBtn(
                    onPressed: () {
                      CustomBottomSheet.show(
                          context: context,
                          child: UploadOptionSheet(patient: widget.patient));
                    },
                  )
                : null
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Stack(
          children: [
            Skeletonizer(
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
                        const OfflineBanner(),
                        Row(
                          children: [
                            Expanded(
                              child: DocumentFilterBar(
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
                            ),
                            FilterIcon(
                                sheet: DocumentFilterSheet(
                              initialOption: filterOption,
                              initialSortOptions: sortOrder,
                              onApply: (selectedOption, selectedSortOrder) {
                                setState(() {
                                  filterOption = selectedOption;
                                  sortOrder = selectedSortOrder;
                                });
                                _fetchAllDocumentsSummary(
                                    categories[selectedIndex]);
                              },
                            ))
                          ],
                        ),
                        Expanded(
                            child: (isLoading == false && documentList.isEmpty)
                                ? const Center(
                                    child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 30),
                                    child: BodyText(
                                      text: 'No documents found yet.',
                                      textAlign: TextAlign.center,
                                    ),
                                  ))
                                : SingleChildScrollView(
                                    padding: const EdgeInsets.only(bottom: 80),
                                    child: MaxWidthConstrainedBox(
                                      child: Accordion(
                                        maxOpenSections: 1,
                                        disableScrolling: true,
                                        headerBackgroundColor: Theme.of(context)
                                            .extension<CustomColors>()
                                            ?.primarySurface,
                                        headerBackgroundColorOpened:
                                            Colors.blue.shade50,
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
                                              visitTime: doc.dateOfVisit,
                                              testTime: doc.dateOfTest,
                                              summary: doc.summary,
                                              type: doc.documentType,
                                              filterOption: filterOption,
                                              fullAccess: fullAccess,
                                              selectedMode: selectedMode,
                                              isSelected:
                                                  selectedIds.contains(doc.id),
                                              onLongPress: (id) {
                                                setState(() {
                                                  selectedMode = true;
                                                  selectedIds.add(id);
                                                });
                                              },
                                              onSelect: (id) {
                                                setState(() {
                                                  if (selectedIds
                                                      .contains(id)) {
                                                    selectedIds.remove(id);
                                                  } else {
                                                    selectedIds.add(id);
                                                  }
                                                });
                                              });
                                        }).toList(),
                                      ),
                                    )))
                      ],
                    ),
            ),
            // ✅ Bottom selection bar
            if (selectedMode)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SelectionBottomBar(
                  selectedCount: selectedIds.length,
                  fullAccess: fullAccess,
                  isLoading: isLoadShare,
                  onShare: () {
                    _fetchDocumentReference();
                  },
                  onDelete: () {
                    showConfirmDialog(
                      context: context,
                      title: "Delete Documents",
                      message:
                          "Are you sure you want to delete this documents?",
                      onConfirm: () {
                        setState(() {
                          isLoading = true;
                        });
                        _deleteDocuments();
                      },
                    );
                  },
                ),
              ),
          ],
        ));
  }
}
