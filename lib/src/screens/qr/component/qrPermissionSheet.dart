import 'package:care_sync/src/bloc/userBloc.dart';
import 'package:care_sync/src/screens/qr/component/qrGenerateSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/apiHandler/apiHandler.dart';
import '../../../component/bottomSheet/bottomSheet.dart';
import '../../../component/btn/primaryBtn/priamaryLoadingBtn.dart';
import '../../../component/dropdown/simpleEnumDropdown.dart';
import '../../../component/text/sectionTittleText.dart';
import '../../../models/enums/careGiverPermission.dart';
import '../../../service/api/httpService.dart';

class QRPermissionSheet extends StatefulWidget {
  const QRPermissionSheet({super.key});

  @override
  State<QRPermissionSheet> createState() => _QRPermissionSheetState();
}

class _QRPermissionSheetState extends State<QRPermissionSheet> {
  final _formKey = GlobalKey<FormState>();
  late final HttpService httpService;

  bool _isInitialized = false;
  CareGiverPermission careGiverPermission = CareGiverPermission.VIEW_ONLY;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      httpService = HttpService(context.read<UserBloc>());

      _isInitialized = true;
    }
  }

  Future<void> _generateQrToken() async {
    setState(() => isLoading = true);

    await ApiHandler.handleApiCall<String>(
      context: context,
      request: () => httpService.careGiverRequestService
          .generateQrToken(careGiverPermission.name),
      onSuccess: (qrToken, msg) {
        Navigator.of(context).pop();
        CustomBottomSheet.show(
            context: context,
            child: QrGenerateSheet(
              qrToken: qrToken,
            ));
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
                const SectionTittleText(text: 'Choose Caregiver Access'),
                const SizedBox(height: 20),
                SimpleEnumDropdownField(
                  labelText: "Permission",
                  initialValue: careGiverPermission,
                  values: CareGiverPermission.values,
                  onChanged: (value) {
                    careGiverPermission = value!;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                PrimaryLoadingBtn(
                  label: 'Generate QR Code',
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _generateQrToken();
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
