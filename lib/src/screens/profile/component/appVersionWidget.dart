import 'package:care_sync/src/component/text/subText.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionWidget extends StatelessWidget {
  const AppVersionWidget({super.key});
  Future<String> _getAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return "V ${info.version} (${info.buildNumber})";
    } catch (e, st) {
      debugPrint("❌ Failed to get version: $e\n$st");
      return "Version unavailable";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getAppVersion(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        return Padding(
            padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
            child: SubText(text: snapshot.data!));
      },
    );
  }
}
