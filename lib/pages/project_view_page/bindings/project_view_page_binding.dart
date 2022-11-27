import 'package:get/get.dart';
import 'package:gps_video_link/pages/project_view_page/controllers/project_view_page_controller.dart';


class ProjectViewPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProjectViewPageController());
  }
}
