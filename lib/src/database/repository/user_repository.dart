import 'package:care_sync/src/database/app_database.dart';
import 'package:drift/drift.dart';

class UserRepository {
  final AppDatabase db;

  UserRepository(this.db);

  Future<void> saveCaregiverAssignments(
    List<dynamic> data,
    AppDatabase db,
  ) async {
    for (final item in data) {
      final caregiver = item['caregiver'];
      final patient = item['patient'];

      // 🔹 1. Insert / Update Caregiver
      await db.into(db.users).insertOnConflictUpdate(
            UsersCompanion(
              id: Value(caregiver['id']),
              name: Value(caregiver['name']),
              email: Value(caregiver['email']),
              role: Value(caregiver['role']),
            ),
          );

      // 🔹 2. Insert / Update Patient
      await db.into(db.users).insertOnConflictUpdate(
            UsersCompanion(
              id: Value(patient['id']),
              name: Value(patient['name']),
              email: Value(patient['email']),
              role: Value(patient['role']),
            ),
          );

      // 🔹 3. Insert / Update Assignment
      await db.into(db.careGiverAssignments).insertOnConflictUpdate(
            CareGiverAssignmentsCompanion(
              id: Value(item['id']),
              caregiverId: Value(caregiver['id']),
              patientId: Value(patient['id']),
              permission: Value(item['permission']),
            ),
          );
    }
  }
}
