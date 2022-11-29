import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gpx/gpx.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../services/storage_service.dart';
import '../../../services/write_file.dart';
import '../../../shared_components/db_model.dart';
import '../../../utils/constants.dart';
import '../../main_page/controllers/main_page_controller.dart';

class CameraViewPageController extends GetxController {
  final MainPageController _mainPageController = Get.put(MainPageController());

  List<CameraDescription>? _cameras;
  CameraController? cameraController;

  StreamSubscription<Position>? _positionStream;

  Gpx? _gpx;

  bool controllerInit = false;
  bool cameraRecording = false;
  bool cameraChange = false;

  late PermissionStatus _cameraPermissionStatus;
  late PermissionStatus _locationPermissionStatus;
  late PermissionStatus _storagePermissionStatus;

  String _projectName = "";


  NativeDeviceOrientation? orientation;

  String _gpxFilePath = "";
  String _recordVideoPath = "";

  @override
  void onInit() {
    super.onInit();
    KeepScreenOn.turnOn();
    controllerInitialize();
  }

  @override
  void onClose() {
    super.onClose();
    if (cameraController != null) {
      cameraController!.dispose();
    }
    _disposePositionStream();
    KeepScreenOn.turnOff();
  }

  void controllerInitialize() async {
    controllerInit = false;
    update();
    await awaitPermission();

    if (checkPermission()) {
      await _cameraInitialize();
      _gpxInitialize();
    }
    controllerInit = true;
    update();
  }

  void _gpxInitialize() {
    _gpx = Gpx();
    _gpx!.metadata = Metadata(name: _projectName, time: DateTime.now());
  }

  Future<void> awaitPermission() async {
    _cameraPermissionStatus = await Permission.camera.request();
    _locationPermissionStatus = await Permission.location.request();
    _storagePermissionStatus = await Permission.manageExternalStorage.request();
  }

  Future<void> _cameraInitialize() async {
    _cameras = await availableCameras();
    cameraController = CameraController(_cameras![0], ResolutionPreset.medium,
        enableAudio: false);
    await cameraController!.initialize();
  }

  void changeCameraRecord() async {
    if (cameraRecording) {
      _recordStop();

      // await cameraController!.pausePreview();
      // cameraController!.stopVideoRecording();
      // final path = await StorageService.localGpxPath;
      // _recordVideoPath = "$path/$_projectName.mp4";
      // file.saveTo(_recordVideoPath);
      //
      // _disposePositionStream();
      // _gpxFilePath = await WriteFile()
      //     .writeGpxFile(GpxWriter().asString(_gpx!), "$_projectName.xml");
      //
      // _insertDB();
      // _mainPageController.getDBData();
      // StorageService.deleteCacheDir;

      cameraRecording = false;
      update();
      return;
    } else {
      _recordStart();
      // cameraController!.startVideoRecording();
      // _positionStream =
      //     Geolocator.getPositionStream().listen((Position? position) {
      //   if (position != null) {
      //     _gpx!.wpts.add(Wpt(
      //         lat: position.latitude,
      //         lon: position.longitude,
      //         time: position.timestamp));
      //   }
      // });

      cameraRecording = true;
      update();
      return;
    }
    // update();
  }

  void changeCameraOrientation(String orientationName) {
    if (orientationName == DeviceOrientation.portraitUp.name) {
      cameraController!.lockCaptureOrientation(DeviceOrientation.portraitUp);
    } else if (orientationName == DeviceOrientation.landscapeLeft.name) {
      cameraController!.lockCaptureOrientation(DeviceOrientation.landscapeLeft);
    } else if (orientationName == DeviceOrientation.landscapeRight.name) {
      cameraController!
          .lockCaptureOrientation(DeviceOrientation.landscapeRight);
    } else {
      cameraController!.lockCaptureOrientation(DeviceOrientation.portraitDown);
    }
  }

  void _disposePositionStream() {
    if (_positionStream != null) {
      _positionStream!.cancel();
      _positionStream = null;
    }
  }

  bool checkPermission() {
    if (_cameraPermissionStatus.isGranted &&
        _locationPermissionStatus.isGranted &&
        _storagePermissionStatus.isGranted) {
      return true;
    }
    return false;
  }

  void _insertDB() async {
    DBModel model = DBModel(
      projectName: _projectName,
      createDateTime: DateTime.now().toIso8601String(),
      gpxPath: _gpxFilePath,
      videoPath: _recordVideoPath,
    );
    await _mainPageController.database
        .insert(Constants.databaseTableName, model.toMap());
  }

  Future<bool> willPop() async {
    bool back = false;
    if (cameraRecording) {
      await Get.defaultDialog(
        onConfirm: () {
          back = true;
          Get.back();
        },
        radius: 5,
        title: "",
        middleText:
            "Идет запись. Вы уверены, что хотите выйти? Файл будет потерян",
        textCancel: "отмена",
        textConfirm: "да",
      );
    } else {
      back = true;
    }
    return back;
  }

  Future<void> _recordStart() async {
    _projectName = DateTime.now().toIso8601String().replaceAll(":", "_");
    cameraChange = true;
    await cameraController!.pausePreview();
    update();

    await cameraController!.startVideoRecording();
    _positionStream =
        Geolocator.getPositionStream().listen((Position? position) {
      if (position != null) {
        _gpx!.wpts.add(Wpt(
            lat: position.latitude,
            lon: position.longitude,
            time: position.timestamp));
      }
    });

    await cameraController!.resumePreview();
    cameraChange = false;
    update();
  }

  Future<void> _recordStop() async {
    cameraChange = true;
    await cameraController!.pausePreview();
    update();

    XFile file = await cameraController!.stopVideoRecording();
    final path = await StorageService.localGpxPath;
    _recordVideoPath = "$path/$_projectName.mp4";
    await file.saveTo(_recordVideoPath);

    _disposePositionStream();
    _gpxFilePath = await WriteFile()
        .writeGpxFile(GpxWriter().asString(_gpx!), "$_projectName.xml");

    _insertDB();
    _mainPageController.getDBData();
    StorageService.deleteCacheDir;

    await cameraController!.resumePreview();
    cameraChange = false;
    update();
  }
}
