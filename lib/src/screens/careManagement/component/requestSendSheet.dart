import 'package:care_sync/src/bloc/userBloc.dart';
import 'package:care_sync/src/component/btn/primaryBtn/priamaryLoadingBtn.dart';
import 'package:care_sync/src/models/enums/careGiverPermission.dart';
import 'package:care_sync/src/models/enums/userRole.dart';
import 'package:care_sync/src/models/user/careGiverRequestSent.dart';
import 'package:care_sync/src/theme/customColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/apiHandler/apiHandler.dart';
import '../../../component/dropdown/simpleEnumDropdown.dart';
import '../../../component/snakbar/customSnakbar.dart';
import '../../../component/text/sectionTittleText.dart';
import '../../../component/textField/simpleTextField/simpleTextField.dart';
import '../../../service/api/httpService.dart';

class RequestSendSheet extends StatefulWidget {
  final UserRole userRole;
  const RequestSendSheet({super.key, required this.userRole});

  @override
  State<RequestSendSheet> createState() => _RequestSendSheetState();
}

class _RequestSendSheetState extends State<RequestSendSheet> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  late final HttpService httpService;
  bool _isInitialized = false;
  CareGiverRequestSend careGiverRequestSend = new CareGiverRequestSend(
      patientUserEmail: '', requestedPermission: CareGiverPermission.VIEW_ONLY);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      httpService = HttpService(context.read<UserBloc>());

      _isInitialized = true;
    }
  }

  Future<void> _sendRequest() async {
    setState(() => isLoading = true);

    await ApiHandler.handleApiCall<void>(
      context: context,
      request: () =>
          httpService.careGiverRequestService.sendRequest(careGiverRequestSend),
      onSuccess: (_, msg) {
        CustomSnackbar.showCustomSnackbar(
          context: context,
          message: msg,
          backgroundColor: Theme.of(context).extension<CustomColors>()!.success,
        );
        Navigator.of(context).pop(true);
      },
      onFinally: () => setState(() => isLoading = false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 12),
                SectionTittleText(
                    text: widget.userRole == UserRole.PATIENT
                        ? 'Connect with Caregiver'
                        : 'Connect with Patient'),
                const SizedBox(height: 20),
                SimpleTextField(
                  initialText: careGiverRequestSend.patientUserEmail,
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    careGiverRequestSend.patientUserEmail = value;
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email cannot be empty';
                    }

                    final emailRegExp = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );

                    if (!emailRegExp.hasMatch(value.trim())) {
                      return 'Please enter a valid email address';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SimpleEnumDropdownField(
                  labelText: "Permission",
                  initialValue: careGiverRequestSend.requestedPermission,
                  values: CareGiverPermission.values,
                  onChanged: (value) {
                    careGiverRequestSend.requestedPermission = value!;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                PrimaryLoadingBtn(
                  label: 'Send Request',
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      print(careGiverRequestSend.toJson());
                      _sendRequest();
                    }
                  },
                  loading: isLoading,
                ),
              ],
            ))
      ],
    );
  }
}
