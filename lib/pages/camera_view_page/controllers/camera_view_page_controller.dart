import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

class CameraViewPageController extends GetxController {
  late List<CameraDescription> _cameras;
  late CameraController cameraController;

  bool controllerInit = false;
  bool cameraRecording = false;

  NativeDeviceOrientation? orientation;

  @override
  void onInit() {
    super.onInit();
    KeepScreenOn.turnOn();
    _controllerInitialize();
  }

  @override
  void onClose() {
    super.onClose();
    cameraController.dispose();
    KeepScreenOn.turnOff();
  }

  void _controllerInitialize() async {
    await _cameraInitialize();
    controllerInit = true;
    update();
  }

  Future<void> _cameraInitialize() async {
    _cameras = await availableCameras();
    cameraController =
        CameraController(_cameras[0], ResolutionPreset.medium, enableAudio: false);
    await cameraController.initialize();
  }

  void changeCameraRecord() async {
    if (cameraRecording) {
      XFile file = await cameraController.stopVideoRecording();
      await GallerySaver.saveVideo(file.path);
      cameraRecording = false;
    } else {
      await cameraController.startVideoRecording();
      cameraRecording = true;
    }
    update();
  }

  void changeCameraOrientation(String orientationName) {
    if (orientationName == DeviceOrientation.portraitUp.name) {
      cameraController.lockCaptureOrientation(DeviceOrientation.portraitUp);
    } else if (orientationName == DeviceOrientation.landscapeLeft.name) {
      cameraController.lockCaptureOrientation(DeviceOrientation.landscapeLeft);
    } else if (orientationName == DeviceOrientation.landscapeRight.name) {
      cameraController.lockCaptureOrientation(DeviceOrientation.landscapeRight);
    } else {
      cameraController.lockCaptureOrientation(DeviceOrientation.portraitDown);
    }
  }
}
