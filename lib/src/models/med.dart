import 'enums/intakeInstruction.dart';
import 'enums/medForm.dart';

class Med {
  final int? id;
  final String name;
  final MedForm medForm;
  final String healthCondition;
  final Duration intakeInterval;
  final DateTime startDate;
  final DateTime? endDate;
  final String dosage;
  final int stock;
  final int reminderLimit;
  final IntakeInstruction instruction;

  Med({
    this.id,
    required this.name,
    required this.medForm,
    required this.healthCondition,
    required this.intakeInterval,
    required this.startDate,
    this.endDate,
    required this.dosage,
    required this.stock,
    required this.reminderLimit,
    required this.instruction,
  });

  factory Med.fromJson(Map<String, dynamic> json) => Med(
        id: json['id'],
        name: json['name'],
        medForm: MedForm.fromJson(json['medForm']),
        healthCondition: json['healthCondition'],
        intakeInterval: Duration(seconds: json['intakeInterval']),
        startDate: DateTime.parse(json['startDate']),
        endDate:
            json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
        dosage: json['dosage'],
        stock: json['stock'],
        reminderLimit: json['reminderLimit'],
        instruction: IntakeInstruction.fromJson(json['instruction']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'medForm': medForm.toJson(),
        'healthCondition': healthCondition,
        'intakeInterval': intakeInterval.inSeconds,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'dosage': dosage,
        'stock': stock,
        'reminderLimit': reminderLimit,
        'instruction': instruction.toJson(),
      };
}
