import 'package:care_sync/src/component/appBar/appBar.dart';
import 'package:care_sync/src/component/btn/floatingBtn/floatingBtn.dart';
import 'package:care_sync/src/screens/document/component/uploadOptionSheet.dart';
import 'package:flutter/material.dart';

import '../../component/bottomSheet/bottomSheet.dart';

class DocumentScreen extends StatelessWidget {
  const DocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        tittle: "Medical Document",
      ),
      floatingActionButton: CustomFloatingBtn(
        onPressed: () {
          CustomBottomSheet.show(
              context: context, child:  const UploadOptionSheet());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
