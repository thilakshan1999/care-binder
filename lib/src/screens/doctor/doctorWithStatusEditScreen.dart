import 'package:care_sync/src/models/enums/entityStatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/analyzedDocumentBloc.dart';
import '../../component/appBar/appBar.dart';
import '../../component/btn/primaryBtn/primaryBtn.dart';
import '../../component/textField/multiLine/multiLineTextField.dart';
import '../../component/textField/simpleTextField/simpleTextField.dart';
import '../../models/doctor/doctorWithStatus.dart';

class DoctorWithStatusEditScreen extends StatefulWidget {
  final DoctorWithStatus doctor;
  final int index;

  const DoctorWithStatusEditScreen({
    super.key,
    required this.doctor,
    required this.index,
  });

  @override
  State<DoctorWithStatusEditScreen> createState() =>
      _DoctorWithStatusEditScreenState();
}

class _DoctorWithStatusEditScreenState
    extends State<DoctorWithStatusEditScreen> {
  late DoctorWithStatus updatedDoctor;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    updatedDoctor = widget.doctor.copyWith();
  }

  void saveDoctor() {
    if (_formKey.currentState?.validate() ?? false) {
      if (updatedDoctor.id != null) {
        updatedDoctor.entityStatus = EntityStatus.UPDATED;
      }

      context
          .read<AnalyzedDocumentBloc>()
          .updateDoctor(widget.index, updatedDoctor);
      Navigator.pop(context);
    }
  }

  bool get isFormValid => _formKey.currentState?.validate() ?? false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        tittle: "Edit ${updatedDoctor.name}",
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
                child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            //Name
                            // SimpleTextField(
                            //   initialText: updatedDoctor.name,
                            //   labelText: 'Name',
                            //   onChanged: (value) {
                            //     setState(() {
                            //       updatedDoctor.name = value;
                            //     });
                            //   },
                            //   validator: (value) {
                            //     if (value == null || value.isEmpty) {
                            //       return 'Name cannot be empty';
                            //     }
                            //     return null;
                            //   },
                            // ),
                            // const SizedBox(
                            //   height: 20,
                            // ),
                            //Specialization
                            SimpleTextField(
                              initialText: updatedDoctor.specialization ?? "",
                              labelText: 'Specialization',
                              onChanged: (value) {
                                setState(() {
                                  updatedDoctor.specialization =
                                      value.isEmpty ? null : value;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            //Phone Number
                            SimpleTextField(
                              initialText: updatedDoctor.phoneNumber ?? "",
                              labelText: 'Phone Number',
                              keyboardType: TextInputType.phone,
                              onChanged: (value) {
                                setState(() {
                                  updatedDoctor.phoneNumber =
                                      value.isEmpty ? null : value;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            //Email
                            SimpleTextField(
                              initialText: updatedDoctor.email ?? "",
                              labelText: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                setState(() {
                                  updatedDoctor.email =
                                      value.isEmpty ? null : value;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            //Address
                            MultiLineTextField(
                              initialText: updatedDoctor.address ?? "",
                              labelText: 'Address',
                              onChanged: (value) {
                                updatedDoctor.address =
                                    value.isEmpty ? null : value;
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        )))),
            PrimaryBtn(
              label: 'Save',
              onPressed: saveDoctor,
            ),
          ],
        ),
      ),
    );
  }
}
