import 'package:care_sync/src/component/text/sectionTittleText.dart';
import 'package:care_sync/src/component/textField/simpleTextField/simpleTextField.dart';
import 'package:flutter/material.dart';

class DurationPickerField extends StatelessWidget {
  final Duration? initialDuration;
  final String labelText;
  final ValueChanged<Duration?> onChanged;
  final bool allowClear;

  const DurationPickerField({
    super.key,
    this.initialDuration,
    required this.onChanged,
    this.labelText = 'Select Duration',
    this.allowClear = false,
  });

  String _formatDuration(Duration? duration) {
    if (duration == null) return "Select";
    final months = duration.inDays ~/ 30;
    final days = duration.inDays % 30;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    List<String> parts = [];
    if (months > 0) parts.add("$months M");
    if (days > 0) parts.add("$days D");
    if (hours > 0) parts.add("$hours H");
    if (minutes > 0) parts.add("$minutes Min");

    return parts.isEmpty ? "0 Min" : parts.join(" ");
  }

  Future<void> _pickDuration(BuildContext context) async {
    final result = await showDialog<Duration?>(
      context: context,
      builder: (context) {
        final monthCtrl = TextEditingController();
        final dayCtrl = TextEditingController();
        final hourCtrl = TextEditingController();
        final minuteCtrl = TextEditingController();

        if (initialDuration != null) {
          final totalMinutes = initialDuration!.inMinutes;
          final months = totalMinutes ~/ (30 * 24 * 60);
          final days = (totalMinutes % (30 * 24 * 60)) ~/ (24 * 60);
          final hours = (totalMinutes % (24 * 60)) ~/ 60;
          final minutes = totalMinutes % 60;

          monthCtrl.text = months.toString();
          dayCtrl.text = days.toString();
          hourCtrl.text = hours.toString();
          minuteCtrl.text = minutes.toString();
        }

        // helper function to clamp values
        void clampAndUpdate(TextEditingController ctrl, int max) {
          int val = int.tryParse(ctrl.text) ?? 0;
          if (val > max) {
            ctrl.text = max.toString();
            ctrl.selection = TextSelection.fromPosition(
              TextPosition(offset: ctrl.text.length),
            );
          } else if (val < 0) {
            ctrl.text = "0";
          }
        }

        return AlertDialog(
          title: const SectionTittleText(
            text: "Select Duration",
            textAlign: TextAlign.left,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SimpleTextField(
                        labelText: "Months",
                        keyboardType: TextInputType.number,
                        controller: monthCtrl,
                        initialText: monthCtrl.text,
                        onChanged: (_) => clampAndUpdate(monthCtrl, 11)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SimpleTextField(
                        labelText: "Days",
                        keyboardType: TextInputType.number,
                        controller: dayCtrl,
                        initialText: dayCtrl.text,
                        onChanged: (_) => clampAndUpdate(dayCtrl, 30)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: SimpleTextField(
                        labelText: "Hours",
                        keyboardType: TextInputType.number,
                        controller: hourCtrl,
                        initialText: hourCtrl.text,
                        onChanged: (_) => clampAndUpdate(hourCtrl, 23)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SimpleTextField(
                        labelText: "Minutes",
                        keyboardType: TextInputType.number,
                        controller: minuteCtrl,
                        initialText: minuteCtrl.text,
                        onChanged: (_) => clampAndUpdate(minuteCtrl, 59)),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                int months = int.tryParse(monthCtrl.text) ?? 0;
                int days = int.tryParse(dayCtrl.text) ?? 0;
                int hours = int.tryParse(hourCtrl.text) ?? 0;
                int minutes = int.tryParse(minuteCtrl.text) ?? 0;

                final duration = Duration(
                  days: (months * 30) + days,
                  hours: hours,
                  minutes: minutes,
                );
                Navigator.pop(context, duration);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );

    onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _pickDuration(context),
      child: InputDecorator(
        decoration: InputDecoration(
          label: Text(
            labelText,
            style: TextStyle(
              height: 1,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          border: const OutlineInputBorder(),
          suffixIcon: allowClear && initialDuration != null
              ? IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => onChanged(null),
                )
              : null,
        ),
        child: Text(
          _formatDuration(initialDuration),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
