import 'dart:io';

import 'package:care_sync/src/component/text/btnText.dart';
import 'package:care_sync/src/component/text/sectionTittleText.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadOptionSheet extends StatelessWidget {
  UploadOptionSheet({super.key});

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    final navigator = Navigator.of(context);
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      navigator.push(
        MaterialPageRoute(
          builder: (context) => DisplayImageScreen(imageFile: File(image.path)),
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
            //  Navigator.pop(context);
            // handle file
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

class DisplayImageScreen extends StatelessWidget {
  final File imageFile;

  const DisplayImageScreen({Key? key, required this.imageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Preview')),
      body: Center(
        child: Image.file(imageFile),
      ),
    );
  }
}