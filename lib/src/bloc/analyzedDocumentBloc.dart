import 'package:care_sync/src/models/analyzedDocument.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnalyzedDocumentBloc extends Cubit<AnalyzedDocument?> {
  AnalyzedDocumentBloc() : super(null);

  void setDocument(AnalyzedDocument doc) => emit(doc);
}
