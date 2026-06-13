import 'package:flutter/material.dart';
import 'package:sirius_face_detection_kit/camera/camera_preview.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final interpreter = await Interpreter.fromAsset(
      'assets/tf_models/mobilefacenet.tflite',
    );

    print('SUCCESS');
  } catch (e, s) {
    print('FAILED: $e');

    print(s);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MCameraPreview());
  }
}
