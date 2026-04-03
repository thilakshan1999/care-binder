import 'package:care_sync/src/bloc/userBloc.dart';
import 'package:care_sync/src/database/app_database.dart';
import 'package:care_sync/src/database/repository/document_repository.dart';
import 'package:care_sync/src/database/repository/user_repository.dart';
import 'package:care_sync/src/service/api/httpService.dart';
import 'package:care_sync/src/service/syncService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfflineDataManager {
  static late AppDatabase db;
  static late DocumentRepository documentRepo;
  static late UserRepository userRepo;
  static late SyncService syncService;

  static Future<void> init(BuildContext context) async {
    db = AppDatabase();
    documentRepo = DocumentRepository(db);
    userRepo = UserRepository(db);

    final httpService = HttpService(context.read<UserBloc>());

    syncService = SyncService(
      documentRepo: documentRepo,
      httpService: httpService,
    );
  }
}
