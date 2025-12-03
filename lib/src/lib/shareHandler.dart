

import 'package:flutter/services.dart';

class ShareHandler {
  static const MethodChannel _channel = MethodChannel('carebinder/share');

  /// Get the shared file info (type + file URL)
  static Future<Map<String, dynamic>?> getSharedFile() async {
    try {
      final result = await _channel.invokeMethod('getSharedFile');
      if (result != null) {
        return Map<String, dynamic>.from(result);
      }
    } catch (e) {
      print('❌ Error getting shared file: $e');
    }
    return null;
  }

  /// Delete a specific shared file
  static Future<void> deleteSharedFile(String fileUrl) async {
    try {
      await _channel.invokeMethod('deleteSharedFile', {'fileUrl': fileUrl});
      print('🧹 Shared file deleted: $fileUrl');
    } catch (e) {
      print('❌ Error deleting shared file: $e');
    }
  }

  /// Clear all files inside the shared App Group folder
  static Future<void> clearSharedFolder() async {
    try {
      await _channel.invokeMethod('clearSharedFolder');
      print('🧼 Cleared all shared files');
    } catch (e) {
      print('❌ Error clearing shared folder: $e');
    }
  }
}
