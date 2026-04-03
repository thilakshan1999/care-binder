import 'package:care_sync/src/database/app_database.dart';
import 'package:care_sync/src/models/enums/careGiverPermission.dart';
import 'package:care_sync/src/models/enums/userRole.dart';
import 'package:care_sync/src/models/user/careGiverAssignment.dart';
import 'package:care_sync/src/models/user/userSummary.dart';
import 'package:drift/drift.dart';

class UserRepository {
  final AppDatabase db;

  UserRepository(this.db);

  Future<void> saveCaregiverAssignments(
      List<CareGiverAssignment> assignments) async {
    for (final assignment in assignments) {
      final caregiver = assignment.caregiver;
      final patient = assignment.patient;

      // 🔹 1. Insert / Update Caregiver
      await db.into(db.userTable).insertOnConflictUpdate(
            UserTableCompanion(
              id: Value(caregiver.id),
              name: Value(caregiver.name),
              email: Value(caregiver.email),
              role: Value(caregiver.role.name), // assuming role is enum
            ),
          );

      // 🔹 2. Insert / Update Patient
      await db.into(db.userTable).insertOnConflictUpdate(
            UserTableCompanion(
              id: Value(patient.id),
              name: Value(patient.name),
              email: Value(patient.email),
              role: Value(patient.role.name),
            ),
          );

      // 🔹 3. Insert / Update CareGiverAssignment
      await db.into(db.careGiverAssignmentTable).insertOnConflictUpdate(
            CareGiverAssignmentTableCompanion(
              id: Value(assignment.id),
              caregiverId: Value(caregiver.id),
              patientId: Value(patient.id),
              permission: Value(assignment.permission.name),
            ),
          );
    }
  }

  /// Get all caregivers connected to a patient by patient email
  Future<List<CareGiverAssignment>> getCaregiversByPatientEmail(
      String patientEmail) async {
    final patientRow = await (db.select(db.userTable)
          ..where((u) => u.email.equals(patientEmail)))
        .getSingleOrNull();
    if (patientRow == null) return [];

    final query = (db.select(db.careGiverAssignmentTable)
          ..where((a) => a.patientId.equals(patientRow.id)))
        .join([
      innerJoin(db.userTable,
          db.userTable.id.equalsExp(db.careGiverAssignmentTable.caregiverId))
    ]);

    final rows = await query.get();

    return rows.map((row) {
      final caregiverRow = row.readTable(db.userTable); // caregiver
      return CareGiverAssignment(
        id: row.readTable(db.careGiverAssignmentTable).id,
        caregiver: UserSummary(
          id: caregiverRow.id,
          name: caregiverRow.name,
          email: caregiverRow.email,
          role: UserRole.CAREGIVER,
        ),
        patient: UserSummary(
          id: patientRow.id,
          name: patientRow.name,
          email: patientRow.email,
          role: UserRole.PATIENT,
        ),
        permission: CareGiverPermission.values.firstWhere(
          (e) =>
              e.name == row.readTable(db.careGiverAssignmentTable).permission,
        ),
      );
    }).toList();
  }

  /// Get all patients connected to a caregiver by caregiver email
  Future<List<CareGiverAssignment>> getPatientsByCaregiverEmail(
      String caregiverEmail) async {
    final caregiverRow = await (db.select(db.userTable)
          ..where((u) => u.email.equals(caregiverEmail)))
        .getSingleOrNull();
    if (caregiverRow == null) return [];

    final query = (db.select(db.careGiverAssignmentTable)
          ..where((a) => a.caregiverId.equals(caregiverRow.id)))
        .join([
      innerJoin(db.userTable,
          db.userTable.id.equalsExp(db.careGiverAssignmentTable.patientId))
    ]);

    final rows = await query.get();

    return rows.map((row) {
      final patientRow = row.readTable(db.userTable); // patient
      return CareGiverAssignment(
        id: row.readTable(db.careGiverAssignmentTable).id,
        caregiver: UserSummary(
          id: caregiverRow.id,
          name: caregiverRow.name,
          email: caregiverRow.email,
          role: UserRole.CAREGIVER,
        ),
        patient: UserSummary(
          id: patientRow.id,
          name: patientRow.name,
          email: patientRow.email,
          role: UserRole.PATIENT,
        ),
        permission: CareGiverPermission.values.firstWhere(
          (e) =>
              e.name == row.readTable(db.careGiverAssignmentTable).permission,
        ),
      );
    }).toList();
  }

  Future<int?> getUserIdByEmail(String email) async {
    final user = await (db.select(db.userTable)
          ..where((u) => u.email.equals(email)))
        .getSingleOrNull();

    return user?.id;
  }
}
