import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
      final desc = cameras.first;
      cameraController = CameraController(desc, ResolutionPreset.high);
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

  void processCameraFrame() async {
    try {
      _processing = true;
    } catch (e, s) {
      print(e.toString());
    } finally {
      _processing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return cameraController != null && cameraController!.value.isInitialized
        ? LayoutBuilder(
            builder: (context, constraints) {
              final previewSize = cameraController!.value.previewSize!;
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Center(
                  child: AspectRatio(
                    aspectRatio:
                        max(previewSize.width, previewSize.height) /
                        min(previewSize.width, previewSize.height),
                    child: ClipRect(
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: SizedBox(
                          width: previewSize.height,
                          height: previewSize.width,
                          child: CameraPreview(cameraController!),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        : Center(child: CircularProgressIndicator());
  }
}
