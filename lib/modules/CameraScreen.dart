import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../shared/cubit/cubit.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeCamera(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final appCubit = AppCubit.get(context);
            if (appCubit.cameraController != null &&
                appCubit.cameraController!.value.isInitialized) {
              return Column(
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: appCubit.cameraController!.value.aspectRatio,
                      child: CameraPreview(appCubit.cameraController!),
                    ),
                  ),
                  const SizedBox(height: 100,)
                ],
              );
            } else {
              return Container(
                color: Colors.white, // Placeholder for when camera is not initialized
              );
            }
          } else {
            return const Center(
              child: LinearProgressIndicator(), // Loading indicator while initializing camera
            );
          }
        },
      ),
    );
  }

  Future<void> _initializeCamera(BuildContext context) async {
    final appCubit = AppCubit.get(context);
    if (appCubit.cameraController == null) {
      await appCubit.initializeCamera();
    }
  }
}
