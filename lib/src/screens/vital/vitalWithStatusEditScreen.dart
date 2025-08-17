import 'package:care_sync/src/models/vitalWithStatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/analyzedDocumentBloc.dart';
import '../../component/appBar/appBar.dart';
import '../../component/btn/primaryBtn/primaryBtn.dart';
import '../../component/datePicker/dateTimePickerField.dart';
import '../../component/durationPicker/durationPickerField.dart';
import '../../component/textField/simpleTextField/simpleTextField.dart';
import '../../models/enums/entityStatus.dart';

class VitalWithStatusEditScreen extends StatefulWidget {
  final VitalWithStatus vital;
  final int index;
  const VitalWithStatusEditScreen(
      {super.key, required this.vital, required this.index});

  @override
  State<VitalWithStatusEditScreen> createState() =>
      _VitalWithStatusEditScreenState();
}

class _VitalWithStatusEditScreenState extends State<VitalWithStatusEditScreen> {
  late VitalWithStatus updatedVital;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    updatedVital = widget.vital.copyWith();
  }

  void saveVital() {
    if (_formKey.currentState?.validate() ?? false) {
      if (updatedVital.id != null) {
        updatedVital.entityStatus = EntityStatus.UPDATED;
      }

      context
          .read<AnalyzedDocumentBloc>()
          .updateVitals(widget.index, updatedVital);
      Navigator.pop(context);
    }
  }

  bool get isFormValid => _formKey.currentState?.validate() ?? false;

  @override
  Widget build(BuildContext context) {
    final lastMeasurement = updatedVital.measurements.isNotEmpty
        ? updatedVital.measurements.last
        : null;
    return Scaffold(
      appBar: CustomAppBar(
        tittle: "Edit ${updatedVital.name}",
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
                        children: [
                          //Start Date
                          DateTimePickerField(
                            labelText: "Start Date",
                            initialDateTime: updatedVital.startDateTime,
                            showTime: true,
                            allowClear: true,
                            onChanged: (dateTime) {
                              setState(() {
                                updatedVital.startDateTime = dateTime;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          //Reminder
                          DurationPickerField(
                            initialDuration: updatedVital.remindDuration,
                            labelText: "Reminder Interval",
                            allowClear: true,
                            onChanged: (d) {
                              setState(() => updatedVital.remindDuration = d);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          //Unit
                          SimpleTextField(
                            initialText: updatedVital.unit ?? "",
                            labelText: 'Unit',
                            onChanged: (value) {
                              setState(() {
                                updatedVital.unit =
                                    value.isEmpty ? null : value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          //Last Measured At
                          DateTimePickerField(
                            labelText: "Last Measured At",
                            initialDateTime: lastMeasurement?.dateTime,
                            showTime: true,
                            onChanged: (dateTime) {
                              setState(() {
                                lastMeasurement?.dateTime = dateTime!;
                              });
                            },
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          //Last value
                          SimpleTextField(
                            initialText:
                                lastMeasurement?.value.toString() ?? '',
                            labelText: 'Last value',
                            suffixText: updatedVital.unit,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                lastMeasurement?.value = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ))),
            PrimaryBtn(
              label: 'Save',
              onPressed: saveVital,
            ),
          ],
        ),
      ),
    );
  }
}
