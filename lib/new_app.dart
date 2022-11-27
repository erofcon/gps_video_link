import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

Future<void> main() async {
  // Fetch the available cameras before initializing the app.
  runApp(MaterialApp(builder: (context, child) => const CameraApp(),));
}

class CameraApp extends StatefulWidget {
  const CameraApp({Key? key}) : super(key: key);

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: ()async{
          final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
          GallerySaver.saveVideo(video!.path);
        }, child: Text("press me"),),
      ),
    );
  }
}
