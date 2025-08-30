import 'package:care_sync/src/models/enums/careGiverPermission.dart';
import 'package:care_sync/src/models/user/careGiverAssignment.dart';
import 'package:flutter/material.dart';

import '../../../component/btn/primaryBtn/priamaryLoadingBtn.dart';
import '../../../component/dropdown/simpleEnumDropdown.dart';
import '../../../component/text/sectionTittleText.dart';

class AccessUpdateSheet extends StatefulWidget {
  final CareGiverAssignment member;
  final Function(CareGiverPermission) onUpdate;
  const AccessUpdateSheet(
      {super.key, required this.member, required this.onUpdate});

  @override
  State<AccessUpdateSheet> createState() => _RequestSendSheetState();
}

class _RequestSendSheetState extends State<AccessUpdateSheet> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  late CareGiverPermission permission;

  @override
  void initState() {
    super.initState();
    permission = widget.member.permission;
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
                const SectionTittleText(text: 'Update Permission'),
                const SizedBox(height: 20),
                SimpleEnumDropdownField(
                  labelText: "Permission",
                  initialValue: permission,
                  values: CareGiverPermission.values,
                  onChanged: (value) {
                    permission = value!;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                PrimaryLoadingBtn(
                  label: 'Update',
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      widget.onUpdate(permission);
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
