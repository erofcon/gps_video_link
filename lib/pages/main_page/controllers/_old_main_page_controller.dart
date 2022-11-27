import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gpx/gpx.dart';
import 'package:gps_video_link/services/storage_service.dart';
import 'package:gps_video_link/services/write_file.dart';

import '../../../services/location_service.dart';

class _oldMainPageController extends GetxController {
  final LocationService _locationService = LocationService();
  final Gpx _gpx = Gpx();

  final pageLoading = true.obs;

  List<FileSystemEntity>? saveFilesList;
  WriteFile? writeFile;
  Position? position;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  void initialize() async {
    saveFilesList = await StorageService.gpxFilesList;
    getPermission();
    pageLoading(false);
  }

  @override
  void dispose() {
    super.dispose();
    _locationService.dispose();
  }

  void getPermission() async {
    await _locationService.checkLocationPermission;
  }

  void runLocationPositionStream() {
    _locationService.locationPositionStream((pos) {
      position = pos;
      _gpx.wpts
          .add(Wpt(lat: pos.latitude, lon: pos.longitude, time: pos.timestamp));
      update();
    });
  }

  void stopLocationPositionStream() async {
    _locationService.dispose();
    writeFile = WriteFile();
    writeFile?.writeGpxFile(GpxWriter().asString(_gpx));
  }
}
