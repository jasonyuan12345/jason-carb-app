import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

const LIMITS = {
  "calorie": 30.0,
  "protein": 45.0,
  "sodium": 47.0,
  "carbs": 50.0,
  "fats": 60.0,
  "sugar": 78.0
};

Widget createRoundedContainer()
{
  return Container(

  );
}

class DataLimit
{
  double limit;
  double at;
  String label;

  DataLimit(this.limit, this.at, this.label);
}