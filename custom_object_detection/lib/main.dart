import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite_test/screens/scanning.dart';
import 'package:tflite_test/screens/start.dart';

import 'helper.dart';

List<CameraDescription> cameras;

class AppColors{
  static Color appBarColor = Colors.white12;
  static Color backgroundColor = Color(0xFF1F1F20);
  static Color textColor = Colors.white;
  static Color buttonColor = Colors.white30;

  static var buttonStyle = ElevatedButton.styleFrom(
      primary: AppColors.buttonColor
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  cameras = await availableCameras();

  await prefs.setDouble("calorieIntake", 1).then((value) {print("Saved intake for calories");});
  await prefs.setDouble("calorieLimit", 1).then((value) {print("Saved limit for calories");});

  await prefs.setDouble("proteinIntake", 1).then((value) {print("Saved intake for protein");});
  await prefs.setDouble("proteinLimit", 2).then((value) {print("Saved limit for protein");});

  await prefs.setDouble("sodiumIntake", 2).then((value) {print("Saved intake for sodium");});
  await prefs.setDouble("sodiumLimit", 3).then((value) {print("Saved limit for sodium");});

  await prefs.setDouble("carbsIntake", 3).then((value) {print("Saved intake for carbs");});
  await prefs.setDouble("carbsLimit", 4).then((value) {print("Saved limit for carbs");});

  await prefs.setDouble("fatsIntake", 4).then((value) {print("Saved intake for fats");});
  await prefs.setDouble("fatsLimit", 5).then((value) {print("Saved limit for fats");});

  await prefs.setDouble("sugarIntake", 4).then((value) {print("Saved intake for sugar");});
  await prefs.setDouble("sugarLimit", 6).then((value) {print("Saved limit for sugar");});

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartScreen()
  ));
}

