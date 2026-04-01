import 'package:drift/drift.dart';

class CareGiverAssignments extends Table {
  IntColumn get id => integer()();

  IntColumn get caregiverId => integer()();
  IntColumn get patientId => integer()();

  TextColumn get permission => text()();

  @override
  Set<Column> get primaryKey => {id};
}
