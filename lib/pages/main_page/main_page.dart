import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/routes.dart';
import '../project_view_page/project_view_page.dart';
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
          floatingActionButton: FloatingActionButton(
            onPressed: () => Get.defaultDialog(
              title: "New Project",
              textConfirm: "Ok",
              textCancel: "Cancel",
              radius: 5,
              onCancel: () => Get.back(),
              onConfirm: () {
                Get.back();
                Get.toNamed(Routes.projectView, arguments: {
                  "projectName":
                      controller.projectNameTextEditingController.text,
                });
              },
              middleText: "",
              content: TextFormField(
                controller: controller.projectNameTextEditingController,
              ),
            ).then(
                (value) => controller.projectNameTextEditingController.clear()),
            child: const Icon(Icons.add),
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
                icon: const Icon(Icons.share),
                onPressed: () =>
                    controller.shareFile(controller.saveData[index]["id"]),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () =>
                    controller.deleteDB(controller.saveData[index]['id']),
              ),
            ],
          )
        ),
      ),
    );
  }
}
