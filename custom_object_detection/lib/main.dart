import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  final prefs = await SharedPreferences.getInstance();

  if (!prefs.containsKey("calorieLimit"))
    await prefs.setInt("calorieLimit", 1);
  if (!prefs.containsKey("proteinLimit"))
    await prefs.setDouble("proteinLimit", 1);
  if (!prefs.containsKey("sodiumLimit"))
    await prefs.setDouble("sodiumLimit", 1);
  if (!prefs.containsKey("carbsLimit"))
    await prefs.setDouble("carbsLimit", 1);
  if (!prefs.containsKey("fatsLimit"))
    await prefs.setDouble("fatsLimit", 1);
  if (!prefs.containsKey("sugarLimit"))
    await prefs.setDouble("sugarLimit", 1);

  cameras = await availableCameras();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: StartScreen()
  ));
}

