import 'dart:convert';
import 'package:web/web.dart';

/// Helper class to save the PDF document on the web platform.
class SaveHelper {
  static Future<void> save(List<int> bytes, String fileName) async {
    /// Create an anchor element to download the file.
    HTMLAnchorElement()
      ..href =
          'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}'
      ..setAttribute('download', fileName)
      ..click();
  }
}
