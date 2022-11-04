import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite_test/screens/home_page.dart';
import 'package:tflite_test/screens/start.dart';

List<CameraDescription> cameras;

class AppColors{
  static Color appBarColor = Colors.white12;
  static Color backgroundColor = Colors.white12;
  static Color textColor = Colors.white;
  static Color buttonColor = Colors.white30;

  static var buttonStyle = ElevatedButton.styleFrom(
      primary: AppColors.buttonColor
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: StartScreen()
  ));
}
