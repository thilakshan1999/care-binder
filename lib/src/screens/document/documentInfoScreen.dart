import 'package:care_sync/src/component/text/bodyText.dart';
import 'package:care_sync/src/component/text/sectionTittleText.dart';
import 'package:care_sync/src/component/text/subText.dart';
import 'package:care_sync/src/utils/textFormatUtils.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../component/appBar/appBar.dart';
import '../../component/btn/primaryBtn/priamaryLoadingBtn.dart';
import '../../component/errorBox/ErrorBox.dart';
import '../../component/snakbar/customSnakbar.dart';
import '../../models/analyzedDocument.dart';
import 'component/analyzedScreen/appointmentDocument.dart';
import 'component/analyzedScreen/doctorDocument.dart';
import 'component/analyzedScreen/medDocument.dart';
import 'component/analyzedScreen/vitalDocument.dart';

class DocumentInfoScreen extends StatefulWidget {
  final int id;
  final String name;

  const DocumentInfoScreen({
    super.key,
    required this.id,
    required this.name,
  });

  @override
  State<DocumentInfoScreen> createState() => _DocumentInfoScreenState();
}

class _DocumentInfoScreenState extends State<DocumentInfoScreen> {
  bool isProcessing = false;
  bool isLoading = false;
  bool hasError = false;
  String? errorMessage;
  String? errorTittle;
  AnalyzedDocument? doc;

  @override
  void initState() {
    super.initState();

    doc = AnalyzedDocument.fromJson(sampleAnalyzedDocumentJson);

    setState(() {
      isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          tittle: widget.name,
          showBackButton: true,
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Skeletonizer(
                enabled: isProcessing,
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
                    : SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SectionTittleText(text: "Basic Info"),
                              const SizedBox(
                                height: 10,
                              ),
                              buildInfoRow("Document Name", doc!.documentName),
                              buildInfoRow(
                                  "Document Type",
                                  TextFormatUtils.formatEnum(
                                      doc?.documentType)),
                              buildInfoRow("Document Summary", doc!.summary),
                              const SizedBox(
                                height: 10,
                              ),
                              DoctorDocument(
                                doctors: doc!.doctors,
                                isEditable: false,
                              ),

                              //Med
                              MedDocument(
                                medicines: doc!.medicines,
                                isEditable: false,
                              ),

                              //Appointment
                              AppointmentDocument(
                                appointments: doc!.appointments,
                                isEditable: false,
                              ),

                              //Vital
                              VitalDocument(
                                vitals: doc!.vitals,
                                isEditable: false,
                              ),
                              PrimaryLoadingBtn(
                                label: 'Delete',
                                loading: isLoading,
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                                onPressed: () {
                                  CustomSnackbar.showCustomSnackbar(
                                      context: context,
                                      message: "Cannot delete at this moment",
                                      backgroundColor:
                                          Theme.of(context).colorScheme.error);
                                },
                              ),
                            ]),
                      ))));
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubText(text: label),
          const SizedBox(
            height: 4,
          ),
          BodyText(text: value),
        ],
      ),
    );
  }
}
