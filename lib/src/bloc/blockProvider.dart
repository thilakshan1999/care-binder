import 'package:care_sync/src/bloc/analyzedDocumentBloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocProviders {
  static List<BlocProvider> providers() {
    return [
      BlocProvider<AnalyzedDocumentBloc>(
        create: (context) => AnalyzedDocumentBloc(),
      ),
    ];
  }
}
