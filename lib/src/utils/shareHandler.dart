import 'dart:io';

import 'package:care_sync/src/bloc/userBloc.dart';
import 'package:care_sync/src/component/apiHandler/apiHandler.dart';
import 'package:care_sync/src/component/text/bodyText.dart';
import 'package:care_sync/src/component/text/btnText.dart';
import 'package:care_sync/src/component/text/errorText.dart';
import 'package:care_sync/src/component/text/sectionTittleText.dart';
import 'package:care_sync/src/models/enums/userRole.dart';
import 'package:care_sync/src/models/user/userSummary.dart';
import 'package:care_sync/src/screens/document/textAnalysisScreen.dart';
import 'package:care_sync/src/service/api/httpService.dart';
import 'package:care_sync/src/service/documentPickerService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/user/careGiverAssignment.dart';

class ShareHandler {
  static Uri? lastHandledUri;
  static const MethodChannel _channel = MethodChannel('carebinder/share');

  /// Delete a specific shared file
  static Future<void> deleteSharedFile(String fileUrl) async {
    try {
      await _channel.invokeMethod('deleteSharedFile', {'fileUrl': fileUrl});
      print('🧹 Shared file deleted: $fileUrl');
    } catch (e) {
      print('❌ Error deleting shared file: $e');
    }
  }

  /// Clear all files inside the shared App Group folder
  static Future<void> clearSharedFolder() async {
    try {
      await _channel.invokeMethod('clearSharedFolder');
      print('🧼 Cleared all shared files');
    } catch (e) {
      print('❌ Error clearing shared folder: $e');
    }
  }

  /// Handle incoming share URL and navigate accordingly
  static Future<void> handleIncomingShare(BuildContext context, Uri uri) async {
    final type = uri.queryParameters['type'];
    final fileUrl = uri.queryParameters['file'];

    if (fileUrl == null) return;

    print('📩 Received shared file: $type - $fileUrl');

    final userState = context.read<UserBloc>().state;
    final role = userState.role;

    if (role == UserRole.PATIENT) {
      await _handleForPatient(context, type, fileUrl);
    } else if (role == UserRole.CAREGIVER) {
      await _handleForCaregiver(context, type, fileUrl);
    }
  }

  // 🧠 Handle share for Patient role
  static Future<void> _handleForPatient(
      BuildContext context, String? type, String fileUrl) async {
    if (type == 'image') {
      final imageFile = File.fromUri(Uri.parse(fileUrl));
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => TextAnalysisScreen(
            imageFile: imageFile,
            documentData: null,
            patient: null,
            isFromShare: true,
          ),
        ),
      );
    } else if (type == 'file') {
      final document = DocumentData(
        file: File.fromUri(Uri.parse(fileUrl)),
        mimeType: 'application/pdf',
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => TextAnalysisScreen(
            imageFile: null,
            documentData: document,
            patient: null,
            isFromShare: true,
          ),
        ),
      );
    }
  }

  // 🧠 Handle share for Caregiver role
  static Future<void> _handleForCaregiver(
      BuildContext context, String? type, String fileUrl) async {
    // Show a dialog to select patient
    final selectedPatient = await _showPatientSelectionDialog(context);
    if (selectedPatient == null) return;

    File? imageFile;
    DocumentData? document;

    if (type == 'image') {
      imageFile = File.fromUri(Uri.parse(fileUrl));
    } else if (type == 'file') {
      document = DocumentData(
        file: File.fromUri(Uri.parse(fileUrl)),
        mimeType: 'application/pdf',
      );
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TextAnalysisScreen(
          imageFile: imageFile,
          documentData: document,
          patient: selectedPatient,
          isFromShare: true,
        ),
      ),
    );
  }

  static Future<UserSummary?> _showPatientSelectionDialog(
      BuildContext context) async {
    return showDialog<UserSummary>(
      context: context,
      barrierDismissible: false, // optional: prevent closing while loading
      builder: (context) {
        bool isLoading = true;
        bool hasError = false;
        String? errorMessage;
        List<UserSummary> patients = [];

        // StatefulBuilder lets us update UI inside AlertDialog
        return StatefulBuilder(
          builder: (context, setState) {
            // Start loading immediately (once)
            Future<void> loadPatientsOnce() async {
              if (!isLoading && patients.isNotEmpty) return;
              setState(() {
                isLoading = true;
                hasError = false;
                errorMessage = null;
              });

              try {
                final result = await _loadPatients(context);
                if (result.isEmpty) {
                  setState(() {
                    hasError = true;
                    errorMessage = 'No patients found.';
                  });
                } else {
                  setState(() {
                    patients = result;
                    hasError = false;
                  });
                }
              } catch (e) {
                setState(() {
                  hasError = true;
                  errorMessage = 'Failed to load patients. Please try again.';
                });
                print('❌ Patient load error: $e');
              } finally {
                setState(() => isLoading = false);
              }
            }

            // Kick off loading when dialog opens
            WidgetsBinding.instance.addPostFrameCallback((_) {
              loadPatientsOnce();
            });

            return AlertDialog(
              title: const SectionTittleText(text: 'Select Patient'),
              content: SizedBox(
                width: double.maxFinite,
                child: isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : hasError
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ErrorText(
                                text: errorMessage ?? 'Something went wrong.',
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {
                                  loadPatientsOnce();
                                },
                                child: BtnText(
                                  text: 'Retry',
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: patients.length,
                            itemBuilder: (context, index) {
                              final patient = patients[index];
                              return ListTile(
                                title: BodyText(text: patient.name),
                                onTap: () => Navigator.pop(context, patient),
                              );
                            },
                          ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static Future<List<UserSummary>> _loadPatients(BuildContext context) async {
    try {
      final httpService = HttpService(context.read<UserBloc>());
      List<CareGiverAssignment> members = dummyCareGiverAssignments;

      await ApiHandler.handleApiCall<List<CareGiverAssignment>>(
        context: context,
        request: () =>
            httpService.careGiverAssignmentService.getPatientsOfCaregiver(),
        onSuccess: (data, _) => {members = data},
      );

      final patients = members.map((assignment) {
        return assignment.patient;
      }).toList();

      return patients;
    } catch (e) {
      print('❌ Failed to load patients: $e');
      throw Exception('Failed to load patients');
    }
  }
}
