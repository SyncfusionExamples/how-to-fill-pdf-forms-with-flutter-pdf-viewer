import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Helper class to save the PDF document on Android, iOS, Windows, and macOS.
class SaveHelper {
  static Future<void> save(List<int> bytes, String fileName) async {
    /// Get the temporary directory using the path_provider plugin.
    Directory directory = await getTemporaryDirectory();

    final File file = File('${directory.path}/$fileName');
    if (file.existsSync()) {
      await file.delete();
    }
    await file.writeAsBytes(bytes);
  }
}
