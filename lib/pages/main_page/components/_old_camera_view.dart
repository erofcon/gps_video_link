import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gps_video_link/pages/main_page/components/video_view.dart';

class _old_CameraView extends StatefulWidget {
  const _old_CameraView({Key? key}) : super(key: key);

  @override
  State<_old_CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<_old_CameraView> {
  bool _isLoading = true;
  bool _isRecording = false;

  late CameraController _cameraController;

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _initCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _cameraController = CameraController(camera, ResolutionPreset.max);
    await _cameraController.initialize();

    setState(() {
      _isLoading = false;
    });
  }

  _recordVideo() async {
    if (_isRecording) {
      final file = await _cameraController.stopVideoRecording();
      setState(() {
        _isRecording = false;
      });
      print("${file.path}  main");
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => VideoView(filePath: file.path),
      );

      Navigator.push(context, route);
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            CameraPreview(_cameraController),
            Padding(
              padding: const EdgeInsets.all(25),
              child: FloatingActionButton(
                onPressed: () => _recordVideo(),
                backgroundColor: Colors.red,
                child: Icon(_isRecording ? Icons.stop : Icons.circle),
              ),
            ),
          ],
        ),
      );
    }
  }
}
