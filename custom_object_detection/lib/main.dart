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

  await prefs.setDouble("calorieIntake", 0).then((value) {print("Saved intake for calories");});
  if (!prefs.containsKey("calorieLimit"))
    await prefs.setDouble("calorieLimit", 2000).then((value) {print("Saved limit for calories");});

  await prefs.setDouble("proteinIntake", 0).then((value) {print("Saved intake for protein");});
  if (!prefs.containsKey("proteinLimit"))
    await prefs.setDouble("proteinLimit", 60).then((value) {print("Saved limit for protein");});

  await prefs.setDouble("sodiumIntake", 0).then((value) {print("Saved intake for sodium");});
  if (!prefs.containsKey("sodiumLimit"))
    await prefs.setDouble("sodiumLimit", 2300).then((value) {print("Saved limit for sodium");});

  await prefs.setDouble("carbsIntake", 0).then((value) {print("Saved intake for carbs");});
  if (!prefs.containsKey("carbsLimit"))
    await prefs.setDouble("carbsLimit", 275).then((value) {print("Saved limit for carbs");});

  await prefs.setDouble("fatsIntake", 0).then((value) {print("Saved intake for fats");});
  if (!prefs.containsKey("fatsLimit"))
    await prefs.setDouble("fatsLimit", 97).then((value) {print("Saved limit for fats");});

  await prefs.setDouble("sugarIntake", 0).then((value) {print("Saved intake for sugar");});
  if (!prefs.containsKey("sugarLimit"))
    await prefs.setDouble("sugarLimit", 36).then((value) {print("Saved limit for sugar");});

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartScreen()
  ));
}

