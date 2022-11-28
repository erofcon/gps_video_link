import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gps_video_link/pages/camera_view_page/controllers/camera_view_page_controller.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

import 'components/cameraAppBar.dart';

class CameraVIewPage extends StatelessWidget {
  const CameraVIewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraViewPageController>(builder: (controller) {
      if (!controller.controllerInit) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        return NativeDeviceOrientationReader(
            useSensor: true,
            builder: (context) {
              controller.changeCameraOrientation(
                  NativeDeviceOrientationReader.orientation(context).name);

              return Scaffold(
                  appBar: const CameraAppBar(),
                  body: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        bottom: 0,
                        child: SizedBox(
                          height: context.height,
                          width: context.width,
                          child: controller.cameraController.buildPreview(),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.bottomCenter,
                        child: _CameraBottomBar(),
                      ),
                    ],
                  ),
                  bottomNavigationBar: Container(
                    height: 20,
                    color: Colors.black,
                  ));
            });
      }
    });
  }
}

class _CameraBottomBar extends StatelessWidget {
  const _CameraBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraViewPageController>(
      builder: (controller) => Container(
        height: 150,
        color: Colors.black45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  shape: BoxShape.circle),
              child: IconButton(
                padding: const EdgeInsets.all(1),
                iconSize: 65,
                color: Colors.red,
                onPressed: controller.changeCameraRecord,
                icon: controller.cameraRecording
                    ? const Icon(Icons.stop)
                    : const Icon(Icons.circle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
