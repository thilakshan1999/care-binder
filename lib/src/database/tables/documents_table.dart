import 'package:drift/drift.dart';

class DocumentTable extends Table {
  IntColumn get id => integer()();

  TextColumn get documentName => text()();
  TextColumn get documentType => text()();

  TextColumn get summary => text().nullable()();

  DateTimeColumn get dateOfTest => dateTime().nullable()();
  DateTimeColumn get dateOfVisit => dateTime().nullable()();
  DateTimeColumn get updatedTime => dateTime()();

  TextColumn get fileUrl => text().nullable()(); // 🔥 local file path
  TextColumn get fileName => text().nullable()();
  TextColumn get fileType => text().nullable()();

  IntColumn get userId => integer()();

  BoolColumn get isUpdated => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  TextColumn get doctorsJson => text().nullable()();
  TextColumn get vitalsJson => text().nullable()();
  TextColumn get medicinesJson => text().nullable()();
  TextColumn get appointmentsJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
