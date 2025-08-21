import 'package:care_sync/src/utils/durationFormatUtils.dart';

import '../enums/intakeInstruction.dart';
import '../enums/medForm.dart';

class Med {
  final int id;
  final String name;
  final MedForm medForm;
  final String? healthCondition;
  final Duration? intakeInterval;
  final DateTime startDate;
  final DateTime? endDate;
  final String? dosage;
  final int? stock;
  final int? reminderLimit;
  final IntakeInstruction? instruction;

  Med({
    required this.id,
    required this.name,
    required this.medForm,
    this.healthCondition,
    this.intakeInterval,
    required this.startDate,
    this.endDate,
    this.dosage,
    this.stock,
    this.reminderLimit,
    this.instruction,
  });

  factory Med.fromJson(Map<String, dynamic> json) {
    return Med(
      id: json['id'],
      name: json['name'],
      medForm: MedForm.fromJson(json['medForm']),
      healthCondition: json['healthCondition'],
      intakeInterval:
          DurationFormatUtils.parseIso8601Duration(json['intakeInterval']),
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      dosage: json['dosage'],
      stock: json['stock'],
      reminderLimit: json['reminderLimit'],
      instruction: json['instruction'] != null
          ? IntakeInstruction.fromJson(json['instruction'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'medForm': medForm.toJson(),
        'healthCondition': healthCondition,
        'intakeInterval':
            DurationFormatUtils.formatIso8601Duration(intakeInterval),
        'startDate': startDate.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'dosage': dosage,
        'stock': stock,
        'reminderLimit': reminderLimit,
        'instruction': instruction?.toJson(),
      };
}
