import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/routes.dart';
import 'controllers/main_page_controller.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainPageController>(builder: (controller) {
      if (controller.pageLoading) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        return Scaffold(
          appBar: AppBar(),
          body: const SafeArea(
            child: _DBDataList(),
          ),
          floatingActionButton: SizedBox(
            height: 75,
            width: 75,
            child: FloatingActionButton(
              onPressed: () => Get.toNamed(Routes.cameraView),
              child: const Icon(Icons.camera, size: 45),
            ),
          ),
        );
      }
    });
  }
}

class _DBDataList extends StatelessWidget {
  const _DBDataList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainPageController>(
      builder: (controller) => ListView.builder(
        itemCount: controller.saveData.length,
        itemBuilder: (context, index) => ListTile(
            title: Text(controller.saveData[index]["projectName"]),
            subtitle: Text(controller.saveData[index]["createDateTime"]),
            trailing: Wrap(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.upload_file),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () =>
                      controller.deleteDB(controller.saveData[index]['id']),
                ),
              ],
            )),
      ),
    );
  }
}
