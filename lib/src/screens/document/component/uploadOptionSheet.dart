import 'package:care_sync/src/component/snakbar/customSnakbar.dart';
import 'package:care_sync/src/component/text/btnText.dart';
import 'package:care_sync/src/component/text/sectionTittleText.dart';
import 'package:care_sync/src/screens/document/textAnalysisScreen.dart';
import 'package:care_sync/src/service/documentPickerService.dart';
import 'package:care_sync/src/service/imagePickerService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../models/user/userSummary.dart';

class UploadOptionSheet extends StatelessWidget {
  final UserSummary? patient;
  const UploadOptionSheet({super.key, this.patient});

  // Future<void> _pickImage(ImageSource source, BuildContext context) async {
  //   final navigator = Navigator.of(context);
  //   final imageFile = await ImagePickerService.pickImage(source);
  //   if (imageFile != null) {
  //     navigator.push(
  //       MaterialPageRoute(
  //         builder: (_) => TextAnalysisScreen(
  //           imageFile: imageFile,
  //           patient: patient,
  //         ),
  //       ),
  //     );
  //   }
  // }

Future<void> _pickImage(ImageSource source, BuildContext context) async {
  final navigator = Navigator.of(context);

  // If the source is camera, check camera permission first
  if (source == ImageSource.camera) {
    final status = await Permission.camera.status;

    if (status.isDenied) {
      // Request permission if not granted yet
      final newStatus = await Permission.camera.request();

      if (newStatus.isDenied) {
         CustomSnackbar.showCustomSnackbar(
          context: context,
          message: "Camera permission denied by user.",
        );
        return; // Stop here
      }

      if (newStatus.isPermanentlyDenied) {
        CustomSnackbar.showCustomSnackbar(
          context: context,
          message: "Camera permission permanently denied. Open settings to enable it.",
        );
        return;
      }
    }

    if (status.isPermanentlyDenied) {
       CustomSnackbar.showCustomSnackbar(
          context: context,
          message: "Camera permission permanently denied. Open settings to enable it.",
        );
      return;
    }
  }

  // Pick the image
  final imageFile = await ImagePickerService.pickImage(source);

  if (imageFile != null) {
    navigator.push(
      MaterialPageRoute(
        builder: (_) => TextAnalysisScreen(
          imageFile: imageFile,
          patient: patient,
        ),
      ),
    );
  }
}


  Future<void> _pickDocument(BuildContext context) async {
    final navigator = Navigator.of(context);
    final docData = await DocumentPickerService.pickDocument();

    if (docData != null) {
      navigator.push(
        MaterialPageRoute(
          builder: (_) => TextAnalysisScreen(
            documentData: docData,
            patient: patient,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: SectionTittleText(text: 'Upload Document')),
        _UploadOptionTile(
          icon: Icons.image_outlined,
          label: 'Select from Gallery',
          onTap: () {
            _pickImage(ImageSource.gallery, context);
          },
        ),
        _UploadOptionTile(
          icon: Icons.camera_alt_outlined,
          label: 'Take a Photo',
          onTap: () {
            _pickImage(ImageSource.camera, context);
          },
        ),
        _UploadOptionTile(
          icon: Icons.folder_outlined,
          label: 'Choose File',
          onTap: () {
            _pickDocument(context);
          },
        ),
      ],
    );
  }
}

class _UploadOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _UploadOptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: 32,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      title: BtnText(
        text: label,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      onTap: onTap,
    );
  }
}
