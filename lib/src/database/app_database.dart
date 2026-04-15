import 'dart:io';

import 'package:care_sync/src/database/tables/caregivers_assignment_table.dart';
import 'package:care_sync/src/database/tables/documents_table.dart';
import 'package:care_sync/src/database/tables/users_table.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [UserTable, CareGiverAssignmentTable, DocumentTable],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          // This adds the 'systemEmail' column to the 'userTable'
          // 'userTable' is the field name generated in your _$AppDatabase
          await m.addColumn(userTable, userTable.systemEmail);
        }
      },
      // Optional: useful for debugging to ensure foreign keys work
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}

// 🔹 Create SQLite file in device
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.db'));
    // return NativeDatabase(file);
    return NativeDatabase.createInBackground(file);
  });
}
