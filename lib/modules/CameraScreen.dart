import 'package:camera/camera.dart';
import 'package:diginotefromtodo/modules/loadingScreen.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<CameraDescription>? cameras;
  CameraController? controller;
  String imagePath = "";

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    // Get a list of available cameras
    availableCameras().then((cameraList) {
      cameras = cameraList;
      if (cameras != null && cameras!.isNotEmpty) {
        controller = CameraController(cameras![0], ResolutionPreset.max);
        controller!.initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        if (controller != null && controller!.value.isInitialized)
          Expanded(
            child: Container(
              child: AspectRatio(
                aspectRatio: controller!.value.aspectRatio,
                child: CameraPreview(controller!),
              ),
            ),
          ),
        SizedBox(height: 100,), // Add space between the buttons


      ]),
    );
  }
}


