// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserTableTable extends UserTable
    with TableInfo<$UserTableTable, UserTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _systemEmailMeta =
      const VerificationMeta('systemEmail');
  @override
  late final GeneratedColumn<String> systemEmail = GeneratedColumn<String>(
      'system_email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, email, systemEmail, role];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_table';
  @override
  VerificationContext validateIntegrity(Insertable<UserTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('system_email')) {
      context.handle(
          _systemEmailMeta,
          systemEmail.isAcceptableOrUnknown(
              data['system_email']!, _systemEmailMeta));
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      systemEmail: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}system_email']),
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
    );
  }

  @override
  $UserTableTable createAlias(String alias) {
    return $UserTableTable(attachedDatabase, alias);
  }
}

class UserTableData extends DataClass implements Insertable<UserTableData> {
  final int id;
  final String name;
  final String email;
  final String? systemEmail;
  final String role;
  const UserTableData(
      {required this.id,
      required this.name,
      required this.email,
      this.systemEmail,
      required this.role});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || systemEmail != null) {
      map['system_email'] = Variable<String>(systemEmail);
    }
    map['role'] = Variable<String>(role);
    return map;
  }

  UserTableCompanion toCompanion(bool nullToAbsent) {
    return UserTableCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      systemEmail: systemEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(systemEmail),
      role: Value(role),
    );
  }

  factory UserTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      systemEmail: serializer.fromJson<String?>(json['systemEmail']),
      role: serializer.fromJson<String>(json['role']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'systemEmail': serializer.toJson<String?>(systemEmail),
      'role': serializer.toJson<String>(role),
    };
  }

  UserTableData copyWith(
          {int? id,
          String? name,
          String? email,
          Value<String?> systemEmail = const Value.absent(),
          String? role}) =>
      UserTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        systemEmail: systemEmail.present ? systemEmail.value : this.systemEmail,
        role: role ?? this.role,
      );
  UserTableData copyWithCompanion(UserTableCompanion data) {
    return UserTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      systemEmail:
          data.systemEmail.present ? data.systemEmail.value : this.systemEmail,
      role: data.role.present ? data.role.value : this.role,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('systemEmail: $systemEmail, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, email, systemEmail, role);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.systemEmail == this.systemEmail &&
          other.role == this.role);
}

class UserTableCompanion extends UpdateCompanion<UserTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String?> systemEmail;
  final Value<String> role;
  const UserTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.systemEmail = const Value.absent(),
    this.role = const Value.absent(),
  });
  UserTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String email,
    this.systemEmail = const Value.absent(),
    required String role,
  })  : name = Value(name),
        email = Value(email),
        role = Value(role);
  static Insertable<UserTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? systemEmail,
    Expression<String>? role,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (systemEmail != null) 'system_email': systemEmail,
      if (role != null) 'role': role,
    });
  }

  UserTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? email,
      Value<String?>? systemEmail,
      Value<String>? role}) {
    return UserTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      systemEmail: systemEmail ?? this.systemEmail,
      role: role ?? this.role,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (systemEmail.present) {
      map['system_email'] = Variable<String>(systemEmail.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('systemEmail: $systemEmail, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }
}

class $CareGiverAssignmentTableTable extends CareGiverAssignmentTable
    with
        TableInfo<$CareGiverAssignmentTableTable,
            CareGiverAssignmentTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CareGiverAssignmentTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _caregiverIdMeta =
      const VerificationMeta('caregiverId');
  @override
  late final GeneratedColumn<int> caregiverId = GeneratedColumn<int>(
      'caregiver_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<int> patientId = GeneratedColumn<int>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _permissionMeta =
      const VerificationMeta('permission');
  @override
  late final GeneratedColumn<String> permission = GeneratedColumn<String>(
      'permission', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, caregiverId, patientId, permission];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'care_giver_assignment_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<CareGiverAssignmentTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('caregiver_id')) {
      context.handle(
          _caregiverIdMeta,
          caregiverId.isAcceptableOrUnknown(
              data['caregiver_id']!, _caregiverIdMeta));
    } else if (isInserting) {
      context.missing(_caregiverIdMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('permission')) {
      context.handle(
          _permissionMeta,
          permission.isAcceptableOrUnknown(
              data['permission']!, _permissionMeta));
    } else if (isInserting) {
      context.missing(_permissionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CareGiverAssignmentTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CareGiverAssignmentTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      caregiverId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}caregiver_id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}patient_id'])!,
      permission: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}permission'])!,
    );
  }

  @override
  $CareGiverAssignmentTableTable createAlias(String alias) {
    return $CareGiverAssignmentTableTable(attachedDatabase, alias);
  }
}

class CareGiverAssignmentTableData extends DataClass
    implements Insertable<CareGiverAssignmentTableData> {
  final int id;
  final int caregiverId;
  final int patientId;
  final String permission;
  const CareGiverAssignmentTableData(
      {required this.id,
      required this.caregiverId,
      required this.patientId,
      required this.permission});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['caregiver_id'] = Variable<int>(caregiverId);
    map['patient_id'] = Variable<int>(patientId);
    map['permission'] = Variable<String>(permission);
    return map;
  }

  CareGiverAssignmentTableCompanion toCompanion(bool nullToAbsent) {
    return CareGiverAssignmentTableCompanion(
      id: Value(id),
      caregiverId: Value(caregiverId),
      patientId: Value(patientId),
      permission: Value(permission),
    );
  }

  factory CareGiverAssignmentTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CareGiverAssignmentTableData(
      id: serializer.fromJson<int>(json['id']),
      caregiverId: serializer.fromJson<int>(json['caregiverId']),
      patientId: serializer.fromJson<int>(json['patientId']),
      permission: serializer.fromJson<String>(json['permission']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'caregiverId': serializer.toJson<int>(caregiverId),
      'patientId': serializer.toJson<int>(patientId),
      'permission': serializer.toJson<String>(permission),
    };
  }

  CareGiverAssignmentTableData copyWith(
          {int? id, int? caregiverId, int? patientId, String? permission}) =>
      CareGiverAssignmentTableData(
        id: id ?? this.id,
        caregiverId: caregiverId ?? this.caregiverId,
        patientId: patientId ?? this.patientId,
        permission: permission ?? this.permission,
      );
  CareGiverAssignmentTableData copyWithCompanion(
      CareGiverAssignmentTableCompanion data) {
    return CareGiverAssignmentTableData(
      id: data.id.present ? data.id.value : this.id,
      caregiverId:
          data.caregiverId.present ? data.caregiverId.value : this.caregiverId,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      permission:
          data.permission.present ? data.permission.value : this.permission,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CareGiverAssignmentTableData(')
          ..write('id: $id, ')
          ..write('caregiverId: $caregiverId, ')
          ..write('patientId: $patientId, ')
          ..write('permission: $permission')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, caregiverId, patientId, permission);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CareGiverAssignmentTableData &&
          other.id == this.id &&
          other.caregiverId == this.caregiverId &&
          other.patientId == this.patientId &&
          other.permission == this.permission);
}

class CareGiverAssignmentTableCompanion
    extends UpdateCompanion<CareGiverAssignmentTableData> {
  final Value<int> id;
  final Value<int> caregiverId;
  final Value<int> patientId;
  final Value<String> permission;
  const CareGiverAssignmentTableCompanion({
    this.id = const Value.absent(),
    this.caregiverId = const Value.absent(),
    this.patientId = const Value.absent(),
    this.permission = const Value.absent(),
  });
  CareGiverAssignmentTableCompanion.insert({
    this.id = const Value.absent(),
    required int caregiverId,
    required int patientId,
    required String permission,
  })  : caregiverId = Value(caregiverId),
        patientId = Value(patientId),
        permission = Value(permission);
  static Insertable<CareGiverAssignmentTableData> custom({
    Expression<int>? id,
    Expression<int>? caregiverId,
    Expression<int>? patientId,
    Expression<String>? permission,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (caregiverId != null) 'caregiver_id': caregiverId,
      if (patientId != null) 'patient_id': patientId,
      if (permission != null) 'permission': permission,
    });
  }

  CareGiverAssignmentTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? caregiverId,
      Value<int>? patientId,
      Value<String>? permission}) {
    return CareGiverAssignmentTableCompanion(
      id: id ?? this.id,
      caregiverId: caregiverId ?? this.caregiverId,
      patientId: patientId ?? this.patientId,
      permission: permission ?? this.permission,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (caregiverId.present) {
      map['caregiver_id'] = Variable<int>(caregiverId.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<int>(patientId.value);
    }
    if (permission.present) {
      map['permission'] = Variable<String>(permission.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CareGiverAssignmentTableCompanion(')
          ..write('id: $id, ')
          ..write('caregiverId: $caregiverId, ')
          ..write('patientId: $patientId, ')
          ..write('permission: $permission')
          ..write(')'))
        .toString();
  }
}

class $DocumentTableTable extends DocumentTable
    with TableInfo<$DocumentTableTable, DocumentTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _documentNameMeta =
      const VerificationMeta('documentName');
  @override
  late final GeneratedColumn<String> documentName = GeneratedColumn<String>(
      'document_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _documentTypeMeta =
      const VerificationMeta('documentType');
  @override
  late final GeneratedColumn<String> documentType = GeneratedColumn<String>(
      'document_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _summaryMeta =
      const VerificationMeta('summary');
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
      'summary', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateOfTestMeta =
      const VerificationMeta('dateOfTest');
  @override
  late final GeneratedColumn<DateTime> dateOfTest = GeneratedColumn<DateTime>(
      'date_of_test', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _dateOfVisitMeta =
      const VerificationMeta('dateOfVisit');
  @override
  late final GeneratedColumn<DateTime> dateOfVisit = GeneratedColumn<DateTime>(
      'date_of_visit', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedTimeMeta =
      const VerificationMeta('updatedTime');
  @override
  late final GeneratedColumn<DateTime> updatedTime = GeneratedColumn<DateTime>(
      'updated_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _fileUrlMeta =
      const VerificationMeta('fileUrl');
  @override
  late final GeneratedColumn<String> fileUrl = GeneratedColumn<String>(
      'file_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fileNameMeta =
      const VerificationMeta('fileName');
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
      'file_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fileTypeMeta =
      const VerificationMeta('fileType');
  @override
  late final GeneratedColumn<String> fileType = GeneratedColumn<String>(
      'file_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isUpdatedMeta =
      const VerificationMeta('isUpdated');
  @override
  late final GeneratedColumn<bool> isUpdated = GeneratedColumn<bool>(
      'is_updated', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_updated" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _doctorsJsonMeta =
      const VerificationMeta('doctorsJson');
  @override
  late final GeneratedColumn<String> doctorsJson = GeneratedColumn<String>(
      'doctors_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _vitalsJsonMeta =
      const VerificationMeta('vitalsJson');
  @override
  late final GeneratedColumn<String> vitalsJson = GeneratedColumn<String>(
      'vitals_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _medicinesJsonMeta =
      const VerificationMeta('medicinesJson');
  @override
  late final GeneratedColumn<String> medicinesJson = GeneratedColumn<String>(
      'medicines_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _appointmentsJsonMeta =
      const VerificationMeta('appointmentsJson');
  @override
  late final GeneratedColumn<String> appointmentsJson = GeneratedColumn<String>(
      'appointments_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        documentName,
        documentType,
        summary,
        dateOfTest,
        dateOfVisit,
        updatedTime,
        fileUrl,
        fileName,
        fileType,
        userId,
        isUpdated,
        isDeleted,
        doctorsJson,
        vitalsJson,
        medicinesJson,
        appointmentsJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_table';
  @override
  VerificationContext validateIntegrity(Insertable<DocumentTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('document_name')) {
      context.handle(
          _documentNameMeta,
          documentName.isAcceptableOrUnknown(
              data['document_name']!, _documentNameMeta));
    } else if (isInserting) {
      context.missing(_documentNameMeta);
    }
    if (data.containsKey('document_type')) {
      context.handle(
          _documentTypeMeta,
          documentType.isAcceptableOrUnknown(
              data['document_type']!, _documentTypeMeta));
    } else if (isInserting) {
      context.missing(_documentTypeMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(_summaryMeta,
          summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta));
    }
    if (data.containsKey('date_of_test')) {
      context.handle(
          _dateOfTestMeta,
          dateOfTest.isAcceptableOrUnknown(
              data['date_of_test']!, _dateOfTestMeta));
    }
    if (data.containsKey('date_of_visit')) {
      context.handle(
          _dateOfVisitMeta,
          dateOfVisit.isAcceptableOrUnknown(
              data['date_of_visit']!, _dateOfVisitMeta));
    }
    if (data.containsKey('updated_time')) {
      context.handle(
          _updatedTimeMeta,
          updatedTime.isAcceptableOrUnknown(
              data['updated_time']!, _updatedTimeMeta));
    } else if (isInserting) {
      context.missing(_updatedTimeMeta);
    }
    if (data.containsKey('file_url')) {
      context.handle(_fileUrlMeta,
          fileUrl.isAcceptableOrUnknown(data['file_url']!, _fileUrlMeta));
    }
    if (data.containsKey('file_name')) {
      context.handle(_fileNameMeta,
          fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta));
    }
    if (data.containsKey('file_type')) {
      context.handle(_fileTypeMeta,
          fileType.isAcceptableOrUnknown(data['file_type']!, _fileTypeMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('is_updated')) {
      context.handle(_isUpdatedMeta,
          isUpdated.isAcceptableOrUnknown(data['is_updated']!, _isUpdatedMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('doctors_json')) {
      context.handle(
          _doctorsJsonMeta,
          doctorsJson.isAcceptableOrUnknown(
              data['doctors_json']!, _doctorsJsonMeta));
    }
    if (data.containsKey('vitals_json')) {
      context.handle(
          _vitalsJsonMeta,
          vitalsJson.isAcceptableOrUnknown(
              data['vitals_json']!, _vitalsJsonMeta));
    }
    if (data.containsKey('medicines_json')) {
      context.handle(
          _medicinesJsonMeta,
          medicinesJson.isAcceptableOrUnknown(
              data['medicines_json']!, _medicinesJsonMeta));
    }
    if (data.containsKey('appointments_json')) {
      context.handle(
          _appointmentsJsonMeta,
          appointmentsJson.isAcceptableOrUnknown(
              data['appointments_json']!, _appointmentsJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DocumentTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      documentName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}document_name'])!,
      documentType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}document_type'])!,
      summary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary']),
      dateOfTest: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_of_test']),
      dateOfVisit: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_of_visit']),
      updatedTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_time'])!,
      fileUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_url']),
      fileName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_name']),
      fileType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_type']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      isUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_updated'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      doctorsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}doctors_json']),
      vitalsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vitals_json']),
      medicinesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}medicines_json']),
      appointmentsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}appointments_json']),
    );
  }

  @override
  $DocumentTableTable createAlias(String alias) {
    return $DocumentTableTable(attachedDatabase, alias);
  }
}

class DocumentTableData extends DataClass
    implements Insertable<DocumentTableData> {
  final int id;
  final String documentName;
  final String documentType;
  final String? summary;
  final DateTime? dateOfTest;
  final DateTime? dateOfVisit;
  final DateTime updatedTime;
  final String? fileUrl;
  final String? fileName;
  final String? fileType;
  final int userId;
  final bool isUpdated;
  final bool isDeleted;
  final String? doctorsJson;
  final String? vitalsJson;
  final String? medicinesJson;
  final String? appointmentsJson;
  const DocumentTableData(
      {required this.id,
      required this.documentName,
      required this.documentType,
      this.summary,
      this.dateOfTest,
      this.dateOfVisit,
      required this.updatedTime,
      this.fileUrl,
      this.fileName,
      this.fileType,
      required this.userId,
      required this.isUpdated,
      required this.isDeleted,
      this.doctorsJson,
      this.vitalsJson,
      this.medicinesJson,
      this.appointmentsJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['document_name'] = Variable<String>(documentName);
    map['document_type'] = Variable<String>(documentType);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    if (!nullToAbsent || dateOfTest != null) {
      map['date_of_test'] = Variable<DateTime>(dateOfTest);
    }
    if (!nullToAbsent || dateOfVisit != null) {
      map['date_of_visit'] = Variable<DateTime>(dateOfVisit);
    }
    map['updated_time'] = Variable<DateTime>(updatedTime);
    if (!nullToAbsent || fileUrl != null) {
      map['file_url'] = Variable<String>(fileUrl);
    }
    if (!nullToAbsent || fileName != null) {
      map['file_name'] = Variable<String>(fileName);
    }
    if (!nullToAbsent || fileType != null) {
      map['file_type'] = Variable<String>(fileType);
    }
    map['user_id'] = Variable<int>(userId);
    map['is_updated'] = Variable<bool>(isUpdated);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || doctorsJson != null) {
      map['doctors_json'] = Variable<String>(doctorsJson);
    }
    if (!nullToAbsent || vitalsJson != null) {
      map['vitals_json'] = Variable<String>(vitalsJson);
    }
    if (!nullToAbsent || medicinesJson != null) {
      map['medicines_json'] = Variable<String>(medicinesJson);
    }
    if (!nullToAbsent || appointmentsJson != null) {
      map['appointments_json'] = Variable<String>(appointmentsJson);
    }
    return map;
  }

  DocumentTableCompanion toCompanion(bool nullToAbsent) {
    return DocumentTableCompanion(
      id: Value(id),
      documentName: Value(documentName),
      documentType: Value(documentType),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      dateOfTest: dateOfTest == null && nullToAbsent
          ? const Value.absent()
          : Value(dateOfTest),
      dateOfVisit: dateOfVisit == null && nullToAbsent
          ? const Value.absent()
          : Value(dateOfVisit),
      updatedTime: Value(updatedTime),
      fileUrl: fileUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(fileUrl),
      fileName: fileName == null && nullToAbsent
          ? const Value.absent()
          : Value(fileName),
      fileType: fileType == null && nullToAbsent
          ? const Value.absent()
          : Value(fileType),
      userId: Value(userId),
      isUpdated: Value(isUpdated),
      isDeleted: Value(isDeleted),
      doctorsJson: doctorsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(doctorsJson),
      vitalsJson: vitalsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(vitalsJson),
      medicinesJson: medicinesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(medicinesJson),
      appointmentsJson: appointmentsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(appointmentsJson),
    );
  }

  factory DocumentTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentTableData(
      id: serializer.fromJson<int>(json['id']),
      documentName: serializer.fromJson<String>(json['documentName']),
      documentType: serializer.fromJson<String>(json['documentType']),
      summary: serializer.fromJson<String?>(json['summary']),
      dateOfTest: serializer.fromJson<DateTime?>(json['dateOfTest']),
      dateOfVisit: serializer.fromJson<DateTime?>(json['dateOfVisit']),
      updatedTime: serializer.fromJson<DateTime>(json['updatedTime']),
      fileUrl: serializer.fromJson<String?>(json['fileUrl']),
      fileName: serializer.fromJson<String?>(json['fileName']),
      fileType: serializer.fromJson<String?>(json['fileType']),
      userId: serializer.fromJson<int>(json['userId']),
      isUpdated: serializer.fromJson<bool>(json['isUpdated']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      doctorsJson: serializer.fromJson<String?>(json['doctorsJson']),
      vitalsJson: serializer.fromJson<String?>(json['vitalsJson']),
      medicinesJson: serializer.fromJson<String?>(json['medicinesJson']),
      appointmentsJson: serializer.fromJson<String?>(json['appointmentsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'documentName': serializer.toJson<String>(documentName),
      'documentType': serializer.toJson<String>(documentType),
      'summary': serializer.toJson<String?>(summary),
      'dateOfTest': serializer.toJson<DateTime?>(dateOfTest),
      'dateOfVisit': serializer.toJson<DateTime?>(dateOfVisit),
      'updatedTime': serializer.toJson<DateTime>(updatedTime),
      'fileUrl': serializer.toJson<String?>(fileUrl),
      'fileName': serializer.toJson<String?>(fileName),
      'fileType': serializer.toJson<String?>(fileType),
      'userId': serializer.toJson<int>(userId),
      'isUpdated': serializer.toJson<bool>(isUpdated),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'doctorsJson': serializer.toJson<String?>(doctorsJson),
      'vitalsJson': serializer.toJson<String?>(vitalsJson),
      'medicinesJson': serializer.toJson<String?>(medicinesJson),
      'appointmentsJson': serializer.toJson<String?>(appointmentsJson),
    };
  }

  DocumentTableData copyWith(
          {int? id,
          String? documentName,
          String? documentType,
          Value<String?> summary = const Value.absent(),
          Value<DateTime?> dateOfTest = const Value.absent(),
          Value<DateTime?> dateOfVisit = const Value.absent(),
          DateTime? updatedTime,
          Value<String?> fileUrl = const Value.absent(),
          Value<String?> fileName = const Value.absent(),
          Value<String?> fileType = const Value.absent(),
          int? userId,
          bool? isUpdated,
          bool? isDeleted,
          Value<String?> doctorsJson = const Value.absent(),
          Value<String?> vitalsJson = const Value.absent(),
          Value<String?> medicinesJson = const Value.absent(),
          Value<String?> appointmentsJson = const Value.absent()}) =>
      DocumentTableData(
        id: id ?? this.id,
        documentName: documentName ?? this.documentName,
        documentType: documentType ?? this.documentType,
        summary: summary.present ? summary.value : this.summary,
        dateOfTest: dateOfTest.present ? dateOfTest.value : this.dateOfTest,
        dateOfVisit: dateOfVisit.present ? dateOfVisit.value : this.dateOfVisit,
        updatedTime: updatedTime ?? this.updatedTime,
        fileUrl: fileUrl.present ? fileUrl.value : this.fileUrl,
        fileName: fileName.present ? fileName.value : this.fileName,
        fileType: fileType.present ? fileType.value : this.fileType,
        userId: userId ?? this.userId,
        isUpdated: isUpdated ?? this.isUpdated,
        isDeleted: isDeleted ?? this.isDeleted,
        doctorsJson: doctorsJson.present ? doctorsJson.value : this.doctorsJson,
        vitalsJson: vitalsJson.present ? vitalsJson.value : this.vitalsJson,
        medicinesJson:
            medicinesJson.present ? medicinesJson.value : this.medicinesJson,
        appointmentsJson: appointmentsJson.present
            ? appointmentsJson.value
            : this.appointmentsJson,
      );
  DocumentTableData copyWithCompanion(DocumentTableCompanion data) {
    return DocumentTableData(
      id: data.id.present ? data.id.value : this.id,
      documentName: data.documentName.present
          ? data.documentName.value
          : this.documentName,
      documentType: data.documentType.present
          ? data.documentType.value
          : this.documentType,
      summary: data.summary.present ? data.summary.value : this.summary,
      dateOfTest:
          data.dateOfTest.present ? data.dateOfTest.value : this.dateOfTest,
      dateOfVisit:
          data.dateOfVisit.present ? data.dateOfVisit.value : this.dateOfVisit,
      updatedTime:
          data.updatedTime.present ? data.updatedTime.value : this.updatedTime,
      fileUrl: data.fileUrl.present ? data.fileUrl.value : this.fileUrl,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      fileType: data.fileType.present ? data.fileType.value : this.fileType,
      userId: data.userId.present ? data.userId.value : this.userId,
      isUpdated: data.isUpdated.present ? data.isUpdated.value : this.isUpdated,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      doctorsJson:
          data.doctorsJson.present ? data.doctorsJson.value : this.doctorsJson,
      vitalsJson:
          data.vitalsJson.present ? data.vitalsJson.value : this.vitalsJson,
      medicinesJson: data.medicinesJson.present
          ? data.medicinesJson.value
          : this.medicinesJson,
      appointmentsJson: data.appointmentsJson.present
          ? data.appointmentsJson.value
          : this.appointmentsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentTableData(')
          ..write('id: $id, ')
          ..write('documentName: $documentName, ')
          ..write('documentType: $documentType, ')
          ..write('summary: $summary, ')
          ..write('dateOfTest: $dateOfTest, ')
          ..write('dateOfVisit: $dateOfVisit, ')
          ..write('updatedTime: $updatedTime, ')
          ..write('fileUrl: $fileUrl, ')
          ..write('fileName: $fileName, ')
          ..write('fileType: $fileType, ')
          ..write('userId: $userId, ')
          ..write('isUpdated: $isUpdated, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('doctorsJson: $doctorsJson, ')
          ..write('vitalsJson: $vitalsJson, ')
          ..write('medicinesJson: $medicinesJson, ')
          ..write('appointmentsJson: $appointmentsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      documentName,
      documentType,
      summary,
      dateOfTest,
      dateOfVisit,
      updatedTime,
      fileUrl,
      fileName,
      fileType,
      userId,
      isUpdated,
      isDeleted,
      doctorsJson,
      vitalsJson,
      medicinesJson,
      appointmentsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentTableData &&
          other.id == this.id &&
          other.documentName == this.documentName &&
          other.documentType == this.documentType &&
          other.summary == this.summary &&
          other.dateOfTest == this.dateOfTest &&
          other.dateOfVisit == this.dateOfVisit &&
          other.updatedTime == this.updatedTime &&
          other.fileUrl == this.fileUrl &&
          other.fileName == this.fileName &&
          other.fileType == this.fileType &&
          other.userId == this.userId &&
          other.isUpdated == this.isUpdated &&
          other.isDeleted == this.isDeleted &&
          other.doctorsJson == this.doctorsJson &&
          other.vitalsJson == this.vitalsJson &&
          other.medicinesJson == this.medicinesJson &&
          other.appointmentsJson == this.appointmentsJson);
}

class DocumentTableCompanion extends UpdateCompanion<DocumentTableData> {
  final Value<int> id;
  final Value<String> documentName;
  final Value<String> documentType;
  final Value<String?> summary;
  final Value<DateTime?> dateOfTest;
  final Value<DateTime?> dateOfVisit;
  final Value<DateTime> updatedTime;
  final Value<String?> fileUrl;
  final Value<String?> fileName;
  final Value<String?> fileType;
  final Value<int> userId;
  final Value<bool> isUpdated;
  final Value<bool> isDeleted;
  final Value<String?> doctorsJson;
  final Value<String?> vitalsJson;
  final Value<String?> medicinesJson;
  final Value<String?> appointmentsJson;
  const DocumentTableCompanion({
    this.id = const Value.absent(),
    this.documentName = const Value.absent(),
    this.documentType = const Value.absent(),
    this.summary = const Value.absent(),
    this.dateOfTest = const Value.absent(),
    this.dateOfVisit = const Value.absent(),
    this.updatedTime = const Value.absent(),
    this.fileUrl = const Value.absent(),
    this.fileName = const Value.absent(),
    this.fileType = const Value.absent(),
    this.userId = const Value.absent(),
    this.isUpdated = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.doctorsJson = const Value.absent(),
    this.vitalsJson = const Value.absent(),
    this.medicinesJson = const Value.absent(),
    this.appointmentsJson = const Value.absent(),
  });
  DocumentTableCompanion.insert({
    this.id = const Value.absent(),
    required String documentName,
    required String documentType,
    this.summary = const Value.absent(),
    this.dateOfTest = const Value.absent(),
    this.dateOfVisit = const Value.absent(),
    required DateTime updatedTime,
    this.fileUrl = const Value.absent(),
    this.fileName = const Value.absent(),
    this.fileType = const Value.absent(),
    required int userId,
    this.isUpdated = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.doctorsJson = const Value.absent(),
    this.vitalsJson = const Value.absent(),
    this.medicinesJson = const Value.absent(),
    this.appointmentsJson = const Value.absent(),
  })  : documentName = Value(documentName),
        documentType = Value(documentType),
        updatedTime = Value(updatedTime),
        userId = Value(userId);
  static Insertable<DocumentTableData> custom({
    Expression<int>? id,
    Expression<String>? documentName,
    Expression<String>? documentType,
    Expression<String>? summary,
    Expression<DateTime>? dateOfTest,
    Expression<DateTime>? dateOfVisit,
    Expression<DateTime>? updatedTime,
    Expression<String>? fileUrl,
    Expression<String>? fileName,
    Expression<String>? fileType,
    Expression<int>? userId,
    Expression<bool>? isUpdated,
    Expression<bool>? isDeleted,
    Expression<String>? doctorsJson,
    Expression<String>? vitalsJson,
    Expression<String>? medicinesJson,
    Expression<String>? appointmentsJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (documentName != null) 'document_name': documentName,
      if (documentType != null) 'document_type': documentType,
      if (summary != null) 'summary': summary,
      if (dateOfTest != null) 'date_of_test': dateOfTest,
      if (dateOfVisit != null) 'date_of_visit': dateOfVisit,
      if (updatedTime != null) 'updated_time': updatedTime,
      if (fileUrl != null) 'file_url': fileUrl,
      if (fileName != null) 'file_name': fileName,
      if (fileType != null) 'file_type': fileType,
      if (userId != null) 'user_id': userId,
      if (isUpdated != null) 'is_updated': isUpdated,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (doctorsJson != null) 'doctors_json': doctorsJson,
      if (vitalsJson != null) 'vitals_json': vitalsJson,
      if (medicinesJson != null) 'medicines_json': medicinesJson,
      if (appointmentsJson != null) 'appointments_json': appointmentsJson,
    });
  }

  DocumentTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? documentName,
      Value<String>? documentType,
      Value<String?>? summary,
      Value<DateTime?>? dateOfTest,
      Value<DateTime?>? dateOfVisit,
      Value<DateTime>? updatedTime,
      Value<String?>? fileUrl,
      Value<String?>? fileName,
      Value<String?>? fileType,
      Value<int>? userId,
      Value<bool>? isUpdated,
      Value<bool>? isDeleted,
      Value<String?>? doctorsJson,
      Value<String?>? vitalsJson,
      Value<String?>? medicinesJson,
      Value<String?>? appointmentsJson}) {
    return DocumentTableCompanion(
      id: id ?? this.id,
      documentName: documentName ?? this.documentName,
      documentType: documentType ?? this.documentType,
      summary: summary ?? this.summary,
      dateOfTest: dateOfTest ?? this.dateOfTest,
      dateOfVisit: dateOfVisit ?? this.dateOfVisit,
      updatedTime: updatedTime ?? this.updatedTime,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      userId: userId ?? this.userId,
      isUpdated: isUpdated ?? this.isUpdated,
      isDeleted: isDeleted ?? this.isDeleted,
      doctorsJson: doctorsJson ?? this.doctorsJson,
      vitalsJson: vitalsJson ?? this.vitalsJson,
      medicinesJson: medicinesJson ?? this.medicinesJson,
      appointmentsJson: appointmentsJson ?? this.appointmentsJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (documentName.present) {
      map['document_name'] = Variable<String>(documentName.value);
    }
    if (documentType.present) {
      map['document_type'] = Variable<String>(documentType.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (dateOfTest.present) {
      map['date_of_test'] = Variable<DateTime>(dateOfTest.value);
    }
    if (dateOfVisit.present) {
      map['date_of_visit'] = Variable<DateTime>(dateOfVisit.value);
    }
    if (updatedTime.present) {
      map['updated_time'] = Variable<DateTime>(updatedTime.value);
    }
    if (fileUrl.present) {
      map['file_url'] = Variable<String>(fileUrl.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (fileType.present) {
      map['file_type'] = Variable<String>(fileType.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (isUpdated.present) {
      map['is_updated'] = Variable<bool>(isUpdated.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (doctorsJson.present) {
      map['doctors_json'] = Variable<String>(doctorsJson.value);
    }
    if (vitalsJson.present) {
      map['vitals_json'] = Variable<String>(vitalsJson.value);
    }
    if (medicinesJson.present) {
      map['medicines_json'] = Variable<String>(medicinesJson.value);
    }
    if (appointmentsJson.present) {
      map['appointments_json'] = Variable<String>(appointmentsJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentTableCompanion(')
          ..write('id: $id, ')
          ..write('documentName: $documentName, ')
          ..write('documentType: $documentType, ')
          ..write('summary: $summary, ')
          ..write('dateOfTest: $dateOfTest, ')
          ..write('dateOfVisit: $dateOfVisit, ')
          ..write('updatedTime: $updatedTime, ')
          ..write('fileUrl: $fileUrl, ')
          ..write('fileName: $fileName, ')
          ..write('fileType: $fileType, ')
          ..write('userId: $userId, ')
          ..write('isUpdated: $isUpdated, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('doctorsJson: $doctorsJson, ')
          ..write('vitalsJson: $vitalsJson, ')
          ..write('medicinesJson: $medicinesJson, ')
          ..write('appointmentsJson: $appointmentsJson')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserTableTable userTable = $UserTableTable(this);
  late final $CareGiverAssignmentTableTable careGiverAssignmentTable =
      $CareGiverAssignmentTableTable(this);
  late final $DocumentTableTable documentTable = $DocumentTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [userTable, careGiverAssignmentTable, documentTable];
}

typedef $$UserTableTableCreateCompanionBuilder = UserTableCompanion Function({
  Value<int> id,
  required String name,
  required String email,
  Value<String?> systemEmail,
  required String role,
});
typedef $$UserTableTableUpdateCompanionBuilder = UserTableCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> email,
  Value<String?> systemEmail,
  Value<String> role,
});

class $$UserTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserTableTable> {
  $$UserTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get systemEmail => $composableBuilder(
      column: $table.systemEmail, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));
}

class $$UserTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserTableTable> {
  $$UserTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get systemEmail => $composableBuilder(
      column: $table.systemEmail, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));
}

class $$UserTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserTableTable> {
  $$UserTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get systemEmail => $composableBuilder(
      column: $table.systemEmail, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);
}

class $$UserTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserTableTable,
    UserTableData,
    $$UserTableTableFilterComposer,
    $$UserTableTableOrderingComposer,
    $$UserTableTableAnnotationComposer,
    $$UserTableTableCreateCompanionBuilder,
    $$UserTableTableUpdateCompanionBuilder,
    (
      UserTableData,
      BaseReferences<_$AppDatabase, $UserTableTable, UserTableData>
    ),
    UserTableData,
    PrefetchHooks Function()> {
  $$UserTableTableTableManager(_$AppDatabase db, $UserTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String?> systemEmail = const Value.absent(),
            Value<String> role = const Value.absent(),
          }) =>
              UserTableCompanion(
            id: id,
            name: name,
            email: email,
            systemEmail: systemEmail,
            role: role,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String email,
            Value<String?> systemEmail = const Value.absent(),
            required String role,
          }) =>
              UserTableCompanion.insert(
            id: id,
            name: name,
            email: email,
            systemEmail: systemEmail,
            role: role,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserTableTable,
    UserTableData,
    $$UserTableTableFilterComposer,
    $$UserTableTableOrderingComposer,
    $$UserTableTableAnnotationComposer,
    $$UserTableTableCreateCompanionBuilder,
    $$UserTableTableUpdateCompanionBuilder,
    (
      UserTableData,
      BaseReferences<_$AppDatabase, $UserTableTable, UserTableData>
    ),
    UserTableData,
    PrefetchHooks Function()>;
typedef $$CareGiverAssignmentTableTableCreateCompanionBuilder
    = CareGiverAssignmentTableCompanion Function({
  Value<int> id,
  required int caregiverId,
  required int patientId,
  required String permission,
});
typedef $$CareGiverAssignmentTableTableUpdateCompanionBuilder
    = CareGiverAssignmentTableCompanion Function({
  Value<int> id,
  Value<int> caregiverId,
  Value<int> patientId,
  Value<String> permission,
});

class $$CareGiverAssignmentTableTableFilterComposer
    extends Composer<_$AppDatabase, $CareGiverAssignmentTableTable> {
  $$CareGiverAssignmentTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get caregiverId => $composableBuilder(
      column: $table.caregiverId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get permission => $composableBuilder(
      column: $table.permission, builder: (column) => ColumnFilters(column));
}

class $$CareGiverAssignmentTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CareGiverAssignmentTableTable> {
  $$CareGiverAssignmentTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get caregiverId => $composableBuilder(
      column: $table.caregiverId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get permission => $composableBuilder(
      column: $table.permission, builder: (column) => ColumnOrderings(column));
}

class $$CareGiverAssignmentTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CareGiverAssignmentTableTable> {
  $$CareGiverAssignmentTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get caregiverId => $composableBuilder(
      column: $table.caregiverId, builder: (column) => column);

  GeneratedColumn<int> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get permission => $composableBuilder(
      column: $table.permission, builder: (column) => column);
}

class $$CareGiverAssignmentTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CareGiverAssignmentTableTable,
    CareGiverAssignmentTableData,
    $$CareGiverAssignmentTableTableFilterComposer,
    $$CareGiverAssignmentTableTableOrderingComposer,
    $$CareGiverAssignmentTableTableAnnotationComposer,
    $$CareGiverAssignmentTableTableCreateCompanionBuilder,
    $$CareGiverAssignmentTableTableUpdateCompanionBuilder,
    (
      CareGiverAssignmentTableData,
      BaseReferences<_$AppDatabase, $CareGiverAssignmentTableTable,
          CareGiverAssignmentTableData>
    ),
    CareGiverAssignmentTableData,
    PrefetchHooks Function()> {
  $$CareGiverAssignmentTableTableTableManager(
      _$AppDatabase db, $CareGiverAssignmentTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CareGiverAssignmentTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$CareGiverAssignmentTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CareGiverAssignmentTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> caregiverId = const Value.absent(),
            Value<int> patientId = const Value.absent(),
            Value<String> permission = const Value.absent(),
          }) =>
              CareGiverAssignmentTableCompanion(
            id: id,
            caregiverId: caregiverId,
            patientId: patientId,
            permission: permission,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int caregiverId,
            required int patientId,
            required String permission,
          }) =>
              CareGiverAssignmentTableCompanion.insert(
            id: id,
            caregiverId: caregiverId,
            patientId: patientId,
            permission: permission,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CareGiverAssignmentTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $CareGiverAssignmentTableTable,
        CareGiverAssignmentTableData,
        $$CareGiverAssignmentTableTableFilterComposer,
        $$CareGiverAssignmentTableTableOrderingComposer,
        $$CareGiverAssignmentTableTableAnnotationComposer,
        $$CareGiverAssignmentTableTableCreateCompanionBuilder,
        $$CareGiverAssignmentTableTableUpdateCompanionBuilder,
        (
          CareGiverAssignmentTableData,
          BaseReferences<_$AppDatabase, $CareGiverAssignmentTableTable,
              CareGiverAssignmentTableData>
        ),
        CareGiverAssignmentTableData,
        PrefetchHooks Function()>;
typedef $$DocumentTableTableCreateCompanionBuilder = DocumentTableCompanion
    Function({
  Value<int> id,
  required String documentName,
  required String documentType,
  Value<String?> summary,
  Value<DateTime?> dateOfTest,
  Value<DateTime?> dateOfVisit,
  required DateTime updatedTime,
  Value<String?> fileUrl,
  Value<String?> fileName,
  Value<String?> fileType,
  required int userId,
  Value<bool> isUpdated,
  Value<bool> isDeleted,
  Value<String?> doctorsJson,
  Value<String?> vitalsJson,
  Value<String?> medicinesJson,
  Value<String?> appointmentsJson,
});
typedef $$DocumentTableTableUpdateCompanionBuilder = DocumentTableCompanion
    Function({
  Value<int> id,
  Value<String> documentName,
  Value<String> documentType,
  Value<String?> summary,
  Value<DateTime?> dateOfTest,
  Value<DateTime?> dateOfVisit,
  Value<DateTime> updatedTime,
  Value<String?> fileUrl,
  Value<String?> fileName,
  Value<String?> fileType,
  Value<int> userId,
  Value<bool> isUpdated,
  Value<bool> isDeleted,
  Value<String?> doctorsJson,
  Value<String?> vitalsJson,
  Value<String?> medicinesJson,
  Value<String?> appointmentsJson,
});

class $$DocumentTableTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentTableTable> {
  $$DocumentTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get documentName => $composableBuilder(
      column: $table.documentName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get documentType => $composableBuilder(
      column: $table.documentType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateOfTest => $composableBuilder(
      column: $table.dateOfTest, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateOfVisit => $composableBuilder(
      column: $table.dateOfVisit, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedTime => $composableBuilder(
      column: $table.updatedTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileUrl => $composableBuilder(
      column: $table.fileUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileType => $composableBuilder(
      column: $table.fileType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isUpdated => $composableBuilder(
      column: $table.isUpdated, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get doctorsJson => $composableBuilder(
      column: $table.doctorsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get vitalsJson => $composableBuilder(
      column: $table.vitalsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get medicinesJson => $composableBuilder(
      column: $table.medicinesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get appointmentsJson => $composableBuilder(
      column: $table.appointmentsJson,
      builder: (column) => ColumnFilters(column));
}

class $$DocumentTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentTableTable> {
  $$DocumentTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get documentName => $composableBuilder(
      column: $table.documentName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get documentType => $composableBuilder(
      column: $table.documentType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateOfTest => $composableBuilder(
      column: $table.dateOfTest, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateOfVisit => $composableBuilder(
      column: $table.dateOfVisit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedTime => $composableBuilder(
      column: $table.updatedTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileUrl => $composableBuilder(
      column: $table.fileUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileType => $composableBuilder(
      column: $table.fileType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isUpdated => $composableBuilder(
      column: $table.isUpdated, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get doctorsJson => $composableBuilder(
      column: $table.doctorsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get vitalsJson => $composableBuilder(
      column: $table.vitalsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get medicinesJson => $composableBuilder(
      column: $table.medicinesJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get appointmentsJson => $composableBuilder(
      column: $table.appointmentsJson,
      builder: (column) => ColumnOrderings(column));
}

class $$DocumentTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentTableTable> {
  $$DocumentTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get documentName => $composableBuilder(
      column: $table.documentName, builder: (column) => column);

  GeneratedColumn<String> get documentType => $composableBuilder(
      column: $table.documentType, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<DateTime> get dateOfTest => $composableBuilder(
      column: $table.dateOfTest, builder: (column) => column);

  GeneratedColumn<DateTime> get dateOfVisit => $composableBuilder(
      column: $table.dateOfVisit, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedTime => $composableBuilder(
      column: $table.updatedTime, builder: (column) => column);

  GeneratedColumn<String> get fileUrl =>
      $composableBuilder(column: $table.fileUrl, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get fileType =>
      $composableBuilder(column: $table.fileType, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<bool> get isUpdated =>
      $composableBuilder(column: $table.isUpdated, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<String> get doctorsJson => $composableBuilder(
      column: $table.doctorsJson, builder: (column) => column);

  GeneratedColumn<String> get vitalsJson => $composableBuilder(
      column: $table.vitalsJson, builder: (column) => column);

  GeneratedColumn<String> get medicinesJson => $composableBuilder(
      column: $table.medicinesJson, builder: (column) => column);

  GeneratedColumn<String> get appointmentsJson => $composableBuilder(
      column: $table.appointmentsJson, builder: (column) => column);
}

class $$DocumentTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DocumentTableTable,
    DocumentTableData,
    $$DocumentTableTableFilterComposer,
    $$DocumentTableTableOrderingComposer,
    $$DocumentTableTableAnnotationComposer,
    $$DocumentTableTableCreateCompanionBuilder,
    $$DocumentTableTableUpdateCompanionBuilder,
    (
      DocumentTableData,
      BaseReferences<_$AppDatabase, $DocumentTableTable, DocumentTableData>
    ),
    DocumentTableData,
    PrefetchHooks Function()> {
  $$DocumentTableTableTableManager(_$AppDatabase db, $DocumentTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> documentName = const Value.absent(),
            Value<String> documentType = const Value.absent(),
            Value<String?> summary = const Value.absent(),
            Value<DateTime?> dateOfTest = const Value.absent(),
            Value<DateTime?> dateOfVisit = const Value.absent(),
            Value<DateTime> updatedTime = const Value.absent(),
            Value<String?> fileUrl = const Value.absent(),
            Value<String?> fileName = const Value.absent(),
            Value<String?> fileType = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<bool> isUpdated = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String?> doctorsJson = const Value.absent(),
            Value<String?> vitalsJson = const Value.absent(),
            Value<String?> medicinesJson = const Value.absent(),
            Value<String?> appointmentsJson = const Value.absent(),
          }) =>
              DocumentTableCompanion(
            id: id,
            documentName: documentName,
            documentType: documentType,
            summary: summary,
            dateOfTest: dateOfTest,
            dateOfVisit: dateOfVisit,
            updatedTime: updatedTime,
            fileUrl: fileUrl,
            fileName: fileName,
            fileType: fileType,
            userId: userId,
            isUpdated: isUpdated,
            isDeleted: isDeleted,
            doctorsJson: doctorsJson,
            vitalsJson: vitalsJson,
            medicinesJson: medicinesJson,
            appointmentsJson: appointmentsJson,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String documentName,
            required String documentType,
            Value<String?> summary = const Value.absent(),
            Value<DateTime?> dateOfTest = const Value.absent(),
            Value<DateTime?> dateOfVisit = const Value.absent(),
            required DateTime updatedTime,
            Value<String?> fileUrl = const Value.absent(),
            Value<String?> fileName = const Value.absent(),
            Value<String?> fileType = const Value.absent(),
            required int userId,
            Value<bool> isUpdated = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String?> doctorsJson = const Value.absent(),
            Value<String?> vitalsJson = const Value.absent(),
            Value<String?> medicinesJson = const Value.absent(),
            Value<String?> appointmentsJson = const Value.absent(),
          }) =>
              DocumentTableCompanion.insert(
            id: id,
            documentName: documentName,
            documentType: documentType,
            summary: summary,
            dateOfTest: dateOfTest,
            dateOfVisit: dateOfVisit,
            updatedTime: updatedTime,
            fileUrl: fileUrl,
            fileName: fileName,
            fileType: fileType,
            userId: userId,
            isUpdated: isUpdated,
            isDeleted: isDeleted,
            doctorsJson: doctorsJson,
            vitalsJson: vitalsJson,
            medicinesJson: medicinesJson,
            appointmentsJson: appointmentsJson,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DocumentTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DocumentTableTable,
    DocumentTableData,
    $$DocumentTableTableFilterComposer,
    $$DocumentTableTableOrderingComposer,
    $$DocumentTableTableAnnotationComposer,
    $$DocumentTableTableCreateCompanionBuilder,
    $$DocumentTableTableUpdateCompanionBuilder,
    (
      DocumentTableData,
      BaseReferences<_$AppDatabase, $DocumentTableTable, DocumentTableData>
    ),
    DocumentTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserTableTableTableManager get userTable =>
      $$UserTableTableTableManager(_db, _db.userTable);
  $$CareGiverAssignmentTableTableTableManager get careGiverAssignmentTable =>
      $$CareGiverAssignmentTableTableTableManager(
          _db, _db.careGiverAssignmentTable);
  $$DocumentTableTableTableManager get documentTable =>
      $$DocumentTableTableTableManager(_db, _db.documentTable);
}
