import '../utils/durationFormatUtils.dart';
import 'enums/entityStatus.dart';
import 'enums/intakeInstruction.dart';
import 'enums/medForm.dart';

class MedWithStatus {
  final int? id;
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
  final EntityStatus entityStatus;

  MedWithStatus({
    this.id,
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
    required this.entityStatus,
  });

  factory MedWithStatus.fromJson(Map<String, dynamic> json) {
    Duration? parseIso8601Duration(String? input) {
      if (input == null) return null;
      final regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?');
      final match = regex.firstMatch(input);
      if (match == null) return null;

      final hours = int.tryParse(match.group(1) ?? '0') ?? 0;
      final minutes = int.tryParse(match.group(2) ?? '0') ?? 0;
      final seconds = int.tryParse(match.group(3) ?? '0') ?? 0;

      return Duration(hours: hours, minutes: minutes, seconds: seconds);
    }

    return MedWithStatus(
      id: json['id'],
      name: json['name'],
      medForm: MedForm.fromJson(json['medForm']),
      healthCondition: json['healthCondition'],
      intakeInterval: parseIso8601Duration(json['intakeInterval']),
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      dosage: json['dosage'],
      stock: json['stock'],
      reminderLimit: json['reminderLimit'],
      instruction: json['instruction'] != null
          ? IntakeInstruction.fromJson(json['instruction'])
          : null,
      entityStatus: EntityStatus.fromJson(json['entityStatus']),
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
        'entityStatus': entityStatus.toJson(),
      };
}
