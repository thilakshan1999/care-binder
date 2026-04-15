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
import 'package:care_sync/src/database/offlineDataManager.dart';
import 'package:care_sync/src/models/document/documentReference.dart';
import 'package:care_sync/src/models/enums/careGiverPermission.dart';
import 'package:care_sync/src/models/enums/documentFilterOption.dart';
import 'package:care_sync/src/models/enums/documentType.dart';
import 'package:care_sync/src/models/task/uploadTask.dart';
import 'package:care_sync/src/models/user/userSummary.dart';
import 'package:care_sync/src/screens/document/component/documentFilterSheet.dart';
import 'package:care_sync/src/screens/document/component/taskCard.dart';
import 'package:care_sync/src/screens/document/component/uploadOptionSheet.dart';
import 'package:care_sync/src/screens/document/component/selectionBottomBar.dart';
import 'package:care_sync/src/service/connectivityService.dart';
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
  List<UploadTask> taskList = [];
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
  void initState() {
    super.initState();
    connectivityService.addListener(_onConnectivityChange);
  }

  @override
  void dispose() {
    connectivityService.removeListener(_onConnectivityChange);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      httpService = HttpService(context.read<UserBloc>());
      _fetchAllDocumentsSummary(null);
      _isInitialized = true;
    }
  }

  void _onConnectivityChange() {
    if (mounted) {
      _fetchAllDocumentsSummary(categories[selectedIndex]);
      setState(() {});
    }
  }

  Future<void> _fetchAllDocumentsSummary(String? type) async {
    setState(() {
      documentList = [];
      taskList = [];
      isLoading = true;
      hasError = false;
      errorMessage = null;
      errorTittle = null;
    });

    if (connectivityService.isOnline) {
      _fetchDocumentListApi(type);
    } else {
      _fetchDocumentsLocally(type);
    }
  }

  Future<void> _fetchDocumentReference() async {
    setState(() => isLoadShare = true);

    if (connectivityService.isOnline) {
      _fetchDocumentReferenceApi();
    } else {
      _fetchDocumentReferencesLocally();
    }
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

  Future<void> _shareDocuments(List<DocumentReference> docs) async {
    try {
      final directory = await getTemporaryDirectory();
      final List<XFile> sharedFiles = [];

      for (final doc in docs) {
        if (doc.signedUrl.isEmpty) continue;

        if (connectivityService.isOffline) {
          // ✅ Offline file → directly use
          final file = File(doc.signedUrl);
          if (await file.exists()) {
            sharedFiles.add(XFile(file.path));
          }
        } else {
          // ✅ Online file → download first
          final filePath = '${directory.path}/${doc.fileName}';
          final file = File(filePath);

          final response = await http.get(Uri.parse(doc.signedUrl));
          if (response.statusCode == 200) {
            await file.writeAsBytes(response.bodyBytes);
            sharedFiles.add(XFile(filePath));
          } else {
            debugPrint('Failed to download ${doc.fileName}');
          }
        }
      }

      if (sharedFiles.isEmpty) {
        throw Exception("No files available to share");
      }

      final params = ShareParams(
        files: sharedFiles,
        text:
            'Shared medical records for ${widget.patient?.name ?? context.read<UserBloc>().state.name ?? 'Patient'} via CareBinder.',
      );

      await SharePlus.instance.share(params);

      // 🔹 Cleanup only temp (downloaded) files
      for (final file in sharedFiles) {
        final tempFile = File(file.path);

        if (tempFile.path.contains(directory.path)) {
          if (await tempFile.exists()) {
            await tempFile.delete();
            debugPrint('🗑️ Deleted temp file: ${tempFile.path}');
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Error sharing files: $e');

      CustomSnackbar.showCustomSnackbar(
        context: context,
        message: 'Failed to share documents.',
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } finally {
      setState(() {
        isLoadShare = false;
        selectedMode = false;
        selectedIds.clear();
      });
    }
  }

  //online
  Future<void> _fetchDocumentListApi(String? type) async {
    await ApiHandler.handleApiCall<List<DocumentSummary>>(
      context: context,
      request: () => httpService.documentService.getAllDocumentsSummary(
          type: type,
          patientId: widget.patient?.id,
          filterBy: filterOption.name,
          sortOrder: sortOrder.name),
      onSuccess: (data, _) {
        if (type != null && type != "All") {
          setState(() {
            documentList = data;
            isLoading = false;
            hasError = false;
            errorMessage = null;
            errorTittle = null;
            taskList.clear();
          });
        } else {
          _fetchUploadTask();
          setState(() {
            documentList = data;
          });
        }
      },
      onError: (title, message) {
        setState(() {
          isLoading = false;
          hasError = true;
          errorMessage = message;
          errorTittle = title;
        });
      },
    );
  }

  Future<void> _fetchUploadTask() async {
    await ApiHandler.handleApiCall<List<UploadTask>>(
      context: context,
      request: () => httpService.uploadTaskService.getUserTasks(
        patientId: widget.patient?.id,
      ),
      onSuccess: (data, _) {
        setState(() {
          taskList = data;
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

  Future<void> _fetchDocumentReferenceApi() async {
    await ApiHandler.handleApiCall<List<DocumentReference>>(
      context: context,
      request: () =>
          httpService.documentService.getDocumentsFileUrls(selectedIds),
      onSuccess: (data, _) async {
        await _shareDocuments(data);
      },
      onError: (message, title) {
        setState(() => isLoadShare = false);
        CustomSnackbar.showCustomSnackbar(
          context: context,
          message: message,
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      },
    );
  }

  //offline
  Future<void> _fetchDocumentsLocally(String? type) async {
    try {
      int? userid = await OfflineDataManager.userRepo
          .getUserIdByEmail(context.read<UserBloc>().state.email!);

      if (userid == null) {
        print("User id is missing");
        return;
      }

      int id = widget.patient != null ? widget.patient!.id : userid;

      List<DocumentSummary> data = await OfflineDataManager.documentRepo
          .getDocumentsByUser(id, type, filterOption.name, sortOrder.name);

      if (mounted) {
        setState(() {
          documentList = data;
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

  Future<void> _fetchDocumentReferencesLocally() async {
    try {
      final docs = await OfflineDataManager.documentRepo
          .getDocumentReferencesByIds(selectedIds);

      await _shareDocuments(docs);
    } catch (e) {
      setState(() => isLoadShare = false);

      CustomSnackbar.showCustomSnackbar(
        context: context,
        message: 'Failed to share offline documents.',
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    }
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
                ? connectivityService.isOnline
                    ? CustomFloatingBtn(
                        onPressed: () {
                          CustomBottomSheet.show(
                              context: context,
                              child:
                                  UploadOptionSheet(patient: widget.patient));
                        },
                      )
                    : null
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
                                        child: Column(
                                      children: [
                                        if (taskList.isNotEmpty)
                                          ...taskList.map((task) => TaskCard(
                                                task: task,
                                                context: context,
                                                selectedMode: selectedMode,
                                                fullAccess: fullAccess,
                                                patientId: widget.patient?.id,
                                              )),
                                        Accordion(
                                          maxOpenSections: 1,
                                          disableScrolling: true,
                                          headerBackgroundColor:
                                              Theme.of(context)
                                                  .extension<CustomColors>()
                                                  ?.primarySurface,
                                          headerBackgroundColorOpened:
                                              Colors.blue.shade50,
                                          headerBorderColor:
                                              Colors.blue.shade50,
                                          headerBorderWidth: 1,
                                          paddingListTop: 6,
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
                                                isSelected: selectedIds
                                                    .contains(doc.id),
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
                                      ],
                                    ))))
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
