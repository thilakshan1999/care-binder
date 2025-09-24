import 'package:care_sync/src/component/text/sectionTittleText.dart';
import 'package:care_sync/src/component/text/subText.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrGenerateSheet extends StatelessWidget {
  final String qrToken;
  const QrGenerateSheet({super.key, required this.qrToken});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // make full width
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min, // adapt height to content
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          const SectionTittleText(text: 'Scan QR Code'),
          const SizedBox(height: 20),
          QrImageView(
            data: qrToken,
            version: QrVersions.auto,
            size: 240.0,
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 20),
          const SubText(text: "Scan this QR to connect caregiver"),
        ],
      ),
    );
  }
}
