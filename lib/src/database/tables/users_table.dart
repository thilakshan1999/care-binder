import 'package:drift/drift.dart';

class Users extends Table {
  IntColumn get id => integer()();

  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get role => text()();

  TextColumn get requestsSent => text().nullable()();
  TextColumn get requestsReceived => text().nullable()();
}
