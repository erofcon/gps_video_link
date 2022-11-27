import 'dart:io';

import 'package:gps_video_link/services/storage_service.dart';

class WriteFile {
  final String _gpxFileName = "${DateTime.now().toIso8601String()}.xml";

  Future<File> _getGpxWriterFile() async {
    final path = await StorageService.localGpxPath;

    return File("$path/$_gpxFileName");
  }

  Future<String> writeGpxFile(String value) async {
    final file = await _getGpxWriterFile();
    file.writeAsString(value);
    return file.path;
  }
}
