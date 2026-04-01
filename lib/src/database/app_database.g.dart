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
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, email, role];
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
  final String role;
  const UserTableData(
      {required this.id,
      required this.name,
      required this.email,
      required this.role});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['role'] = Variable<String>(role);
    return map;
  }

  UserTableCompanion toCompanion(bool nullToAbsent) {
    return UserTableCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
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
      'role': serializer.toJson<String>(role),
    };
  }

  UserTableData copyWith(
          {int? id, String? name, String? email, String? role}) =>
      UserTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        role: role ?? this.role,
      );
  UserTableData copyWithCompanion(UserTableCompanion data) {
    return UserTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      role: data.role.present ? data.role.value : this.role,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, email, role);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.role == this.role);
}

class UserTableCompanion extends UpdateCompanion<UserTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String> role;
  const UserTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.role = const Value.absent(),
  });
  UserTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String email,
    required String role,
  })  : name = Value(name),
        email = Value(email),
        role = Value(role);
  static Insertable<UserTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? role,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (role != null) 'role': role,
    });
  }

  UserTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? email,
      Value<String>? role}) {
    return UserTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserTableTable userTable = $UserTableTable(this);
  late final $CareGiverAssignmentTableTable careGiverAssignmentTable =
      $CareGiverAssignmentTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [userTable, careGiverAssignmentTable];
}

typedef $$UserTableTableCreateCompanionBuilder = UserTableCompanion Function({
  Value<int> id,
  required String name,
  required String email,
  required String role,
});
typedef $$UserTableTableUpdateCompanionBuilder = UserTableCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> email,
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
            Value<String> role = const Value.absent(),
          }) =>
              UserTableCompanion(
            id: id,
            name: name,
            email: email,
            role: role,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String email,
            required String role,
          }) =>
              UserTableCompanion.insert(
            id: id,
            name: name,
            email: email,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserTableTableTableManager get userTable =>
      $$UserTableTableTableManager(_db, _db.userTable);
  $$CareGiverAssignmentTableTableTableManager get careGiverAssignmentTable =>
      $$CareGiverAssignmentTableTableTableManager(
          _db, _db.careGiverAssignmentTable);
}
