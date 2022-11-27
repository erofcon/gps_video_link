import 'dart:io';

import 'package:path_provider/path_provider.dart';

class StorageService {
  static Future<String> get localGpxPath async {
    const String gpxFilePath = "gpx/";

    final applicationDirectory = await getApplicationDocumentsDirectory();

    final Directory directory =
        Directory("${applicationDirectory.path}/$gpxFilePath");

    if (await directory.exists()) {
      return directory.path;
    } else {
      final Directory newDirectory = await directory.create(recursive: true);
      return newDirectory.path;
    }
  }

  static Future<String> get localVideoPath async {
    const String videoFilePath = "video/";

    final applicationDirectory = await getApplicationDocumentsDirectory();

    final Directory directory =
        Directory("${applicationDirectory.path}/$videoFilePath");

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

  static Future<List<FileSystemEntity>?> get videoFilesList async {
    String path = await localGpxPath;
    return Directory(path).listSync();
  }

  static Future<void> get deleteCacheDir async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  static Future<void> get deleteAppDir async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }
}
