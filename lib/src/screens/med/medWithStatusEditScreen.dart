import 'package:care_sync/src/models/enums/intakeInstruction.dart';
import 'package:care_sync/src/models/enums/medForm.dart';
import 'package:care_sync/src/models/medWithStatus.dart';
import 'package:care_sync/src/utils/textFormatUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/analyzedDocumentBloc.dart';
import '../../component/appBar/appBar.dart';
import '../../component/btn/primaryBtn/primaryBtn.dart';
import '../../component/datePicker/dateTimePickerField.dart';
import '../../component/dropdown/simpleEnumDropdown.dart';
import '../../component/durationPicker/durationPickerField.dart';
import '../../component/text/primaryText.dart';
import '../../component/textField/simpleTextField/simpleTextField.dart';
import '../../models/enums/entityStatus.dart';

class MedWithStatusEditScreen extends StatefulWidget {
  final MedWithStatus med;
  final int index;
  const MedWithStatusEditScreen(
      {super.key, required this.med, required this.index});

  @override
  State<MedWithStatusEditScreen> createState() =>
      _MedWithStatusEditScreenState();
}

class _MedWithStatusEditScreenState extends State<MedWithStatusEditScreen> {
  late MedWithStatus updatedMed;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    updatedMed = widget.med.copyWith();
  }

  void saveMed() {
    if (_formKey.currentState?.validate() ?? false) {
      if (updatedMed.id != null) {
        updatedMed.entityStatus = EntityStatus.UPDATED;
      }

      context.read<AnalyzedDocumentBloc>().updateMed(widget.index, updatedMed);
      Navigator.pop(context);
    }
  }

  bool get isFormValid => _formKey.currentState?.validate() ?? false;

  @override
  Widget build(BuildContext context) {
    final quantity = TextFormatUtils.parseQuantity(updatedMed.dosage ?? '');
    return Scaffold(
      appBar: CustomAppBar(
        tittle: "Edit ${updatedMed.name}",
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
                child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const PrimaryText(text: "Medical Info"),
                          const SizedBox(
                            height: 20,
                          ),
                          //Medicine Form
                          SimpleEnumDropdownField(
                            labelText: "Medicine Form",
                            initialValue: updatedMed.medForm,
                            values: MedForm.values,
                            onChanged: (value) {
                              updatedMed.medForm = value!;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          //Health Condition
                          SimpleTextField(
                            initialText: updatedMed.healthCondition ?? '',
                            labelText: 'Health Condition',
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              setState(() {
                                if (value.isEmpty) {
                                  updatedMed.healthCondition = null;
                                } else {
                                  updatedMed.healthCondition = value;
                                }
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          //Dosage Unit
                          SimpleTextField(
                            initialText: quantity['unit'] ?? '',
                            labelText: 'Dosage Unit',
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              setState(() {
                                final number = quantity['number'];
                                if (value.isEmpty) {
                                  updatedMed.dosage = number.toString();
                                } else {
                                  updatedMed.dosage =
                                      number != null ? '$number $value' : value;
                                }
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          //Dosage
                          SimpleTextField(
                            initialText: quantity['number'] != null
                                ? quantity['number'].toString()
                                : "",
                            labelText: 'Dosage',
                            keyboardType: TextInputType.number,
                            suffixText: quantity['unit'],
                            onChanged: (value) {
                              setState(() {
                                final unit = quantity['unit'];
                                if (value.isEmpty) {
                                  updatedMed.dosage = quantity['unit'];
                                } else {
                                  updatedMed.dosage =
                                      unit != null ? '$value $unit' : value;
                                }
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          //Instruction
                          SimpleEnumDropdownField(
                            labelText: "Instruction",
                            clearOption: true,
                            initialValue: updatedMed.instruction,
                            values: IntakeInstruction.values,
                            onChanged: (value) {
                              updatedMed.instruction = value;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const PrimaryText(text: "Dates"),
                          const SizedBox(
                            height: 20,
                          ),
                          //Start Date
                          DateTimePickerField(
                            labelText: "Start Date",
                            initialDateTime: updatedMed.startDate,
                            showTime: true,
                            onChanged: (dateTime) {
                              setState(() {
                                updatedMed.startDate = dateTime!;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          //End Date
                          DateTimePickerField(
                            labelText: "End Date",
                            initialDateTime: updatedMed.endDate,
                            showTime: true,
                            allowClear: true,
                            onChanged: (dateTime) {
                              setState(() {
                                updatedMed.endDate = dateTime;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          DurationPickerField(
                            initialDuration: updatedMed.intakeInterval,
                            labelText: "Intake Interval",
                            allowClear: true,
                            onChanged: (d) {
                              setState(() => updatedMed.intakeInterval = d);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const PrimaryText(text: "Inventory"),
                          const SizedBox(
                            height: 20,
                          ),
                          // Stock
                          SimpleTextField(
                            initialText: updatedMed.stock?.toString() ?? '',
                            labelText: 'Stock',
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                if (value.isEmpty) {
                                  updatedMed.stock = null;
                                } else {
                                  updatedMed.stock = int.tryParse(value);
                                }
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // Reminder Limit
                          SimpleTextField(
                            initialText:
                                updatedMed.reminderLimit?.toString() ?? '',
                            labelText: 'Reminder Limit',
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                if (value.isEmpty) {
                                  updatedMed.reminderLimit = null;
                                } else {
                                  updatedMed.reminderLimit =
                                      int.tryParse(value);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ))),
            PrimaryBtn(
              label: 'Save',
              onPressed: saveMed,
            ),
          ],
        ),
      ),
    );
  }
}
