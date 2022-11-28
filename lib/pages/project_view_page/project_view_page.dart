import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gps_video_link/pages/project_view_page/controllers/project_view_page_controller.dart';

class ProjectViewPage extends GetView<ProjectViewPageController> {
  const ProjectViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
      // body: GetBuilder<ProjectViewPageController>(
      //   builder: (controller) {
      //     if (controller.pageLoading) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     } else if (controller.cameraInitialize == false) {
      //       return Container();
      //     } else {
      //       return Stack(
      //         children: <Widget>[
      //           Positioned(
      //             top: 0,
      //             bottom: 0,
      //             child: controller.cameraController.buildPreview(),
      //           ),
      //           Align(
      //             alignment: Alignment.bottomCenter,
      //             child: Container(
      //               height: 150,
      //               color: Colors.black45,
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: <Widget>[
      //                   SizedBox(
      //                     width: 80,
      //                     height: 80,
      //                     child: FloatingActionButton(
      //                       onPressed: controller.changeVideoStream,
      //                       backgroundColor: Colors.red,
      //                       child: Icon(
      //                           size: 55,
      //                           controller.videoStream
      //                               ? Icons.stop
      //                               : Icons.circle),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           )
      //         ],
      //       );
      //     }
      //   },
      // ),
    );
  }
}
