import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gps_video_link/routes/routes.dart';
import 'package:gps_video_link/theme/theme.dart';

import 'localization/localization.dart';

void main() async {
  await initialize();
  runApp(const Application());
}

Future<void> initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
}

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.home,
      getPages: Routes.routes,
      theme: Themes().lightTheme,
      darkTheme: Themes().darkTheme,
      translations: Localization(),
      locale: const Locale('ru', 'RU'),
      fallbackLocale: const Locale('en', 'US'),
      scrollBehavior: CustomScrollBehaviour(),
    );
  }
}

class CustomScrollBehaviour extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
