import 'package:care_sync/src/component/text/btnText.dart';
import 'package:flutter/material.dart';

class DateTimePickerField extends StatelessWidget {
  final DateTime? initialDateTime;
  final String labelText;
  final ValueChanged<DateTime?> onChanged;
  final bool showTime;
  final bool allowClear;

  const DateTimePickerField({
    super.key,
    this.initialDateTime,
    required this.onChanged,
    this.labelText = 'Select Date',
    this.showTime = false,
    this.allowClear = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTime selectDate =
            initialDateTime != null ? initialDateTime! : DateTime.now();
        // Pick date
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (pickedDate == null) return;

        DateTime finalDateTime = pickedDate;

        // Pick time if needed
        if (showTime) {
          final initialTime = TimeOfDay.fromDateTime(selectDate);

          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: initialTime,
          );
          if (pickedTime != null) {
            finalDateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );
          }
        }

        onChanged(finalDateTime);
      },
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
          suffixIcon: allowClear && initialDateTime != null
              ? IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => onChanged(null), // ✅ clear value
                )
              : null,
        ),
        child: BtnText(
          text: initialDateTime != null
              ? showTime
                  ? '${initialDateTime!}'.split('.')[0] // show date & time
                  : '${initialDateTime!}'.split(' ')[0] // only date
              : 'Select',
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
