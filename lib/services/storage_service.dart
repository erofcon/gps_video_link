import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/constants.dart';

class StorageService {
  static Future<String> get localGpxPath async {
    final Directory directory = Directory(Constants.gpxFilePath);

    if (await directory.exists()) {
      return directory.path;
    } else {
      final Directory newDirectory = await directory.create(recursive: true);
      return newDirectory.path;
    }
  }

  static Future<List<FileSystemEntity>?> get gpxFilesList async {
    String path = await localGpxPath;
    return Directory(path).listSync();
  }

  static Future<void> get deleteCacheDir async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }
}
