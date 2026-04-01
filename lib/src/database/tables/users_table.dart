import 'package:drift/drift.dart';

class UserTable extends Table {
  IntColumn get id => integer()();

  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get role => text()();

  @override
  Set<Column> get primaryKey => {id};
}
