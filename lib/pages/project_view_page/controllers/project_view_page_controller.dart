import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:gpx/gpx.dart';
import '../../../services/location_service.dart';
import '../../../services/write_file.dart';
import '../../../shared_components/db_model.dart';
import '../../../utils/constants.dart';
import '../../main_page/controllers/main_page_controller.dart';
import 'package:keep_screen_on/keep_screen_on.dart';


class ProjectViewPageController extends GetxController {
  final MainPageController _mainPageController = Get.put(MainPageController());

  late CameraController cameraController;
  late LocationService _locationService;

  final Gpx _gpx = Gpx();

  final String _projectName =  Get.arguments["projectName"];

  bool pageLoading = true;
  bool cameraInitialize = false;
  bool videoStream = false;

  String? _videoPath;
  String? _gpxPath;

  @override
  void onInit() {
    _controllerInit();
    super.onInit();
  }

  @override
  void onClose() {
    cameraController.dispose();
    _locationService.dispose();
    KeepScreenOn.turnOff();
    super.onClose();
  }

  void _controllerInit() async {
    // Keep the screen on.
    KeepScreenOn.turnOn();

    _gpx.metadata =
        Metadata(name: _projectName, time: DateTime.now());

    _locationService = LocationService();
    final cameras = await availableCameras();
    final camera = cameras.first;
    cameraController =
        CameraController(camera, ResolutionPreset.max, enableAudio: false);

    await _locationService.checkLocationPermission;

    cameraController.initialize().then((value) {

      cameraInitialize = true;
      pageLoading = false;
      update();
    }).catchError((Object e) {
      if (e is CameraException) {
        pageLoading = false;
        update();
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  void changeVideoStream() async {

    XFile file = await cameraController.takePicture();

    GallerySaver.saveImage(file.path);

    // if (videoStream) {
    //   // final file = await cameraController.stopVideoRecording();
    //   // await stopLocationPositionStream();
    //   // _videoPath = file.path;
    //   //
    //   // _insertDB();
    //   // _mainPageController.getDBData();
    //   // videoStream = false;
    //   // GallerySaver.saveVideo(file.path);
    //   // update();
    // } else {
    //   // await cameraController.lockCaptureOrientation(DeviceOrientation.landscapeLeft);
    //   // await cameraController.prepareForVideoRecording();
    //   // await cameraController.startVideoRecording();
    //   // runLocationPositionStream();
    //   // videoStream = true;
    //   // update();
    // }
  }

  void _runLocationPositionStream() {
    _locationService.locationPositionStream((pos) {
      _gpx.wpts
          .add(Wpt(lat: pos.latitude, lon: pos.longitude, time: pos.timestamp));
    });
  }

  Future<void> _stopLocationPositionStream() async {
    _locationService.dispose();
    _gpxPath = await WriteFile().writeGpxFile(GpxWriter().asString(_gpx));
  }

  void _insertDB() async {
    DBModel model = DBModel(
      projectName: _projectName,
      createDateTime: DateTime.now().toIso8601String(),
      gpxPath: _gpxPath!,
      videoPath: _videoPath!,
    );
    await _mainPageController.database.insert(Constants.databaseTableName, model.toMap());
  }

}
