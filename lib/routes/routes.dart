import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:gps_video_link/pages/main_page/main_page.dart';
import 'package:gps_video_link/pages/project_view_page/bindings/project_view_page_binding.dart';

import '../pages/main_page/bindings/main_page_binding.dart';
import '../pages/project_view_page/project_view_page.dart';

class Routes {
  static String home = '/';
  static String projectView = '/projectView';

  static List<GetPage> routes = [
    GetPage(
      name: home,
      page: () => const MainPage(),
      binding: MainPageBinding(),
    ),
    GetPage(
      name: projectView,
      page: () => const ProjectViewPage(),
      binding: ProjectViewPageBinding(),
    ),
  ];
}
