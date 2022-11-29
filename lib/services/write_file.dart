import 'dart:io';

import 'package:gps_video_link/services/storage_service.dart';

class WriteFile {
  Future<String> writeGpxFile(String value, String filename) async {
    final path = await StorageService.localGpxPath;

    final file = File("$path/$filename");
    file.writeAsString(value);
    return file.path;
  }
}
