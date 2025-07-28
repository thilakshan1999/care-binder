import 'package:care_sync/src/component/text/btnText.dart';
import 'package:care_sync/src/component/text/sectionTittleText.dart';
import 'package:flutter/material.dart';

class UploadOptionSheet extends StatelessWidget {
  const UploadOptionSheet({super.key});

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
            // Navigator.pop(context);
            // handle gallery
          },
        ),
        _UploadOptionTile(
          icon: Icons.camera_alt_outlined,
          label: 'Take a Photo',
          onTap: () {
            // Navigator.pop(context);
            // handle camera
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
