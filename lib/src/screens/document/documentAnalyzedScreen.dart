import 'package:care_sync/src/component/dropdown/simpleDropdown.dart';
import 'package:care_sync/src/component/textField/simpleTextField/simpleTextField.dart';
import 'package:care_sync/src/models/analyzedDocument.dart';
import 'package:care_sync/src/models/appointment.dart';
import 'package:care_sync/src/models/enums/documentType.dart';
import 'package:care_sync/src/models/med.dart';
import 'package:care_sync/src/models/vital.dart';
import 'package:care_sync/src/screens/appointment/component/appointmentDetailsSheet.dart';
import 'package:care_sync/src/screens/document/component/analysedScreen/doctorDocument.dart';
import 'package:care_sync/src/screens/document/component/documentSectionHeader.dart';
import 'package:care_sync/src/screens/med/component/medDetailSheet.dart';
import 'package:care_sync/src/screens/vital/component/vitalDetailSheet.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:iconify_flutter/icons/uim.dart';

import '../../component/appBar/appBar.dart';
import '../../component/bottomSheet/bottomSheet.dart';
import '../../component/btn/primaryBtn/primaryBtn.dart';
import '../../component/card/InfoCard.dart';
import '../../component/errorBox/ErrorBox.dart';
import '../../component/textField/multiLine/multiLineTextField.dart';
import '../../service/api/httpService.dart';
import '../../utils/textFormatUtils.dart';
import 'component/documentLoadingIndicator.dart';
import 'package:iconify_flutter/icons/ph.dart';

class DocumentAnalyzedScreen extends StatefulWidget {
  final String extractedText;
  const DocumentAnalyzedScreen({super.key, required this.extractedText});

  @override
  State<DocumentAnalyzedScreen> createState() => _DocumentAnalyzedScreenState();
}

class _DocumentAnalyzedScreenState extends State<DocumentAnalyzedScreen> {
  late AnalyzedDocument document;
  bool isProcessing = true;
  bool hasError = false;
  String? errorMessage;
  String? errorTittle;

  final HttpService httpService = HttpService();

  @override
  void initState() {
    super.initState();
    //_extractDocument(widget.extractedText);
    setState(() {
      document = AnalyzedDocument.fromJson(sampleAnalyzedDocumentJson);
      //sampleAnalyzedDocument;
      isProcessing = false;
    });
  }

  Future<void> _extractDocument(String extractedText) async {
    try {
      final result =
          await httpService.documentService.analyzeDocument(extractedText);

      setState(() {
        if (result.success) {
          document = result.data!;
          hasError = false;
          errorMessage = null;
          errorTittle = null;
        } else {
          hasError = true;
          errorMessage = result.message;
          errorTittle = result.errorTittle ?? "Request Failed";
        }
        isProcessing = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = '$e';
        errorTittle = 'Unexpected Error';
        isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        tittle: isProcessing ? "Analyzing Document" : "Analyzed Document",
        showBackButton: !isProcessing,
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: isProcessing
              ? const DocumentLoadingIndicator(
                  message: "Analyzing document... Please wait.",
                )
              : hasError
                  ? ErrorBox(
                      message: errorMessage ?? 'Something went wrong.',
                      title: errorTittle ?? 'Something went wrong.',
                      onRetry: () {
                        _extractDocument(widget.extractedText);
                        setState(() {
                          isProcessing = true;
                          hasError = false;
                          errorMessage = null;
                          errorTittle = null;
                        });
                      },
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Column(
                                children: [
                                  SimpleTextField(
                                    initialText: document.documentName,
                                    labelText: 'Document Name',
                                    onChanged: (value) {
                                      document.documentName = value;
                                    },
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  SimpleDropdownField<DocumentType>(
                                    initialValue: document.documentType,
                                    values: DocumentType.values,
                                    labelText: "Document Type",
                                    onChanged: (value) {
                                      document.documentType = value;
                                    },
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  MultiLineTextField(
                                    initialText: document.summary,
                                    labelText: 'Summary',
                                    onChanged: (value) {
                                      document.summary = value;
                                    },
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  //Doctor
                                  DoctorDocument(doctors: document.doctors),

                                  //Med
                                  DocumentSectionHeader(
                                    title: "Medicines",
                                    onIconPressed: () {
                                      print("Add Med clicked");
                                    },
                                  ),

                                  // Medicine list -> InfoCard for each
                                  ...document.medicines.map((med) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: InfoCard(
                                        icon: Ph.pill_duotone,
                                        mainText: med.name,
                                        subText: TextFormatUtils.formatEnumName(
                                            med.medForm.name),
                                        status: med.entityStatus,
                                        onTap: () {
                                          CustomBottomSheet.show(
                                              context: context,
                                              child: MedDetailSheet(
                                                med: Med(
                                                    id: 0,
                                                    name: med.name,
                                                    medForm: med.medForm,
                                                    healthCondition:
                                                        med.healthCondition,
                                                    intakeInterval:
                                                        med.intakeInterval,
                                                    startDate: med.startDate,
                                                    endDate: med.endDate,
                                                    dosage: med.dosage,
                                                    stock: med.stock,
                                                    reminderLimit:
                                                        med.reminderLimit,
                                                    instruction:
                                                        med.instruction),
                                              ));
                                        },
                                        onEdit: () {},
                                        onDelete: () {},
                                      ),
                                    );
                                  }),

                                  //Appointment
                                  DocumentSectionHeader(
                                    title: "Appointment",
                                    onIconPressed: () {
                                      print("Add Appointment clicked");
                                    },
                                  ),

                                  // Appointment list -> InfoCard for each
                                  ...document.appointments.map((appointment) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: InfoCard(
                                        icon: Uim.calender,
                                        mainText: appointment.name,
                                        subText: TextFormatUtils.formatEnumName(
                                            appointment.type.name),
                                        status: appointment.entityStatus,
                                        onTap: () {
                                          CustomBottomSheet.show(
                                              context: context,
                                              child: AppointmentDetailSheet(
                                                  appointment: Appointment(
                                                      name: appointment.name,
                                                      type: appointment.type,
                                                      doctor:
                                                          appointment.doctor,
                                                      appointmentDateTime:
                                                          appointment
                                                              .appointmentDateTime,
                                                      id: 0)));
                                        },
                                        onEdit: () {},
                                        onDelete: () {},
                                      ),
                                    );
                                  }),

                                  //Vital
                                  DocumentSectionHeader(
                                    title: "Vitals",
                                    onIconPressed: () {
                                      print("Add vita; clicked");
                                    },
                                  ),

                                  // Vita; list -> InfoCard for each
                                  ...document.vitals.map((vital) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: InfoCard(
                                        icon: Ri.heart_pulse_fill,
                                        mainText: vital.name,
                                        subText: null,
                                        status: vital.entityStatus,
                                        onTap: () {
                                          CustomBottomSheet.show(
                                              context: context,
                                              child: VitalDetailSheet(
                                                vital: Vital(
                                                    id: 0,
                                                    name: vital.name,
                                                    remindDuration:
                                                        vital.remindDuration,
                                                    startDateTime:
                                                        vital.startDateTime,
                                                    unit: vital.unit,
                                                    measurements:
                                                        vital.measurements),
                                              ));
                                        },
                                        onEdit: () {},
                                        onDelete: () {},
                                      ),
                                    );
                                  }),
                                ],
                              )),
                        ),
                        PrimaryBtn(
                          label: 'Save',
                          onPressed: () {
                            print(document.toJson());
                          },
                        ),
                      ],
                    )),
    );
  }
}
