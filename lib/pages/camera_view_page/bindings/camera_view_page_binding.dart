import 'package:get/get.dart';

import '../controllers/camera_view_page_controller.dart';

class CameraViewPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CameraViewPageController());
  }
}
