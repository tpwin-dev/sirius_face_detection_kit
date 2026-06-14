import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

final isDesktopRuntime =
    Platform.isMacOS || Platform.isLinux || Platform.isMacOS;

class MCameraPreview extends StatefulWidget {
  const MCameraPreview({super.key});

  @override
  State<MCameraPreview> createState() => _MCameraPreviewState();
}

class _MCameraPreviewState extends State<MCameraPreview> {
  CameraController? cameraController;
  CameraImage? _lastFrame;
  bool _processing = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final cameras = await availableCameras();

      final desc = cameras.firstWhere(
        (element) =>
            element.lensDirection ==
            (isDesktopRuntime
                ? CameraLensDirection.external
                : CameraLensDirection.front),
      );
      cameraController = CameraController(desc, ResolutionPreset.max);
      await cameraController!.initialize();
      await cameraController!.startImageStream((image) {
        _lastFrame = image;
        if (!_processing) {
          processCameraFrame();
        }
      });
      setState(() {});
    });
  }

  @override
  void dispose() async {
    await cameraController?.stopImageStream();
    await cameraController?.dispose();
    super.dispose();
  }

  void processCameraFrame() async {
    try {
      _processing = true;
      print(_lastFrame!.format.group.name);
    } catch (e, s) {
      print(e.toString());
    } finally {
      // _processing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return cameraController != null && cameraController!.value.isInitialized
        ? LayoutBuilder(
            builder: (context, constraints) {
              final previewSize = cameraController!.value.previewSize!;
              final parentSize = constraints.biggest;
              print(previewSize);
              print(constraints.biggest);
              return Stack(
                children: [
                  Positioned.fill(
                    child: FittedBox(
                      fit: isDesktopRuntime ? .fitWidth : .cover,
                      child: SizedBox(
                        width: previewSize.height,
                        height: isDesktopRuntime ? null : previewSize.width,
                        child: CameraPreview(cameraController!),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: constraints.maxWidth,
                  //   height: constraints.maxHeight,
                  //   child: Center(
                  //     child: AspectRatio(
                  //       aspectRatio:
                  //           max(previewSize.width, previewSize.height) /
                  //           min(previewSize.width, previewSize.height),
                  //       child: ClipRect(
                  //         child: FittedBox(
                  //           fit: BoxFit.fill,
                  //           child: SizedBox(
                  //             width: previewSize.height,
                  //             height: previewSize.width,
                  //             child: CameraPreview(cameraController!),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              );
            },
          )
        : Center(child: CircularProgressIndicator());
  }
}


/*

sirius_face_detection_kit/
  lib/
    detector/
      face_detector.dart
      face_detection_result.dart
    recognition/
      face_embedder.dart
      face_matcher.dart
    image/
      image_preprocessor.dart
      box_mapper.dart
    tflite/
      tflite_runtime.dart

*/