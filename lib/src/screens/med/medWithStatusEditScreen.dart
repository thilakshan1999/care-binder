import 'package:care_sync/src/models/medWithStatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/analyzedDocumentBloc.dart';
import '../../component/appBar/appBar.dart';
import '../../component/btn/primaryBtn/primaryBtn.dart';
import '../../models/enums/entityStatus.dart';

class MedWithStatusEditScreen extends StatefulWidget {
  final MedWithStatus med;
  final int index;
  const MedWithStatusEditScreen(
      {super.key, required this.med, required this.index});

  @override
  State<MedWithStatusEditScreen> createState() =>
      _MedWithStatusEditScreenState();
}

class _MedWithStatusEditScreenState extends State<MedWithStatusEditScreen> {
  late MedWithStatus updatedMed;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    updatedMed = widget.med.copyWith();
  }

  void saveMed() {
    if (_formKey.currentState?.validate() ?? false) {
      if (updatedMed.id != null) {
        updatedMed.entityStatus = EntityStatus.UPDATED;
      }

      context.read<AnalyzedDocumentBloc>().updateMed(widget.index, updatedMed);
      Navigator.pop(context);
    }
  }

  bool get isFormValid => _formKey.currentState?.validate() ?? false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        tittle: "Edit ${updatedMed.name}",
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(child: Form(key: _formKey, child: SizedBox())),
            PrimaryBtn(
              label: 'Save',
              onPressed: saveMed,
            ),
          ],
        ),
      ),
    );
  }
}
