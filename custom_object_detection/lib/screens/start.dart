import 'dart:math';

import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:tflite_test/helper.dart';
import 'package:tflite_test/screens/history.dart';
import 'package:tflite_test/screens/scanning.dart';

import '../main.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {

  TextEditingController limitController = TextEditingController();
  var limits = [];
  var selectedValue;

  var sex;
  var weight_lb;
  var height_in;
  var age;
  var energy_expenditure;

  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  _StartScreenState()
  {
    print("Visited start screen");
    getLimits(LIMITS.keys.toList());
  }

  Future<void> getLimits(List<String> queries) async {
    final prefs = await SharedPreferences.getInstance();
    limits.clear();

    for (String q in queries) {
      double limit, at;
      limit = prefs.getDouble(q + "Limit");
      at = prefs.getDouble(q + "Intake");

      if (limit == null)
        limit = 40;
      if (at == null)
        at = 40;

      setState(() {
        limits.add(new DataLimit(limit.roundToDouble(), at.roundToDouble(), q));
      });
    }
  }

  Future<void> setLimit(String type, double value) async
  {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(type+"Limit", value);
    print(type+"Limit" + " " + value.toString());
    await getLimits(LIMITS.keys.toList());
  }

  void showLimitEditor(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("set your limit"),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButton(
                          value: selectedValue,
                          items: [
                            DropdownMenuItem(
                              child: Text("calorie"),
                              value: "calorie",
                            ),
                            DropdownMenuItem(
                              child: Text("carbs"),
                              value: "carbs",
                            ),
                            DropdownMenuItem(
                              child: Text("fats"),
                              value: "fats",
                            ),
                            DropdownMenuItem(
                              child: Text("sodium"),
                              value: "sodium",
                            ),
                            DropdownMenuItem(
                              child: Text("sugar"),
                              value: "sugar",
                            ),
                            DropdownMenuItem(
                              child: Text("protein"),
                              value: "protein",
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value;
                            });
                          }
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: limitController,
                      )
                    ],
                  );
                }
              ),
              actions: <Widget> [
                ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: Text("back")
                ),
                ElevatedButton(
                    onPressed: () async {
                      await setLimit(selectedValue.toString().toLowerCase(), double.parse(limitController.text));
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.check)
                )
              ]
          );
        }
    );
  }

  double getBMR() {
    if (sex.compareTo("male") == 0) {
      return 66.47 + (6.24 * weight_lb) + (12.7 * height_in) - (6.755 * age);
    }
    else {
      return 655.1 + (4.35 * weight_lb) + (4.7 * height_in) - (4.7 * age);
    }
  }

  double getTEE() {
    switch(energy_expenditure) {
      case 1:
        return 1.2;
      case 2:
        return 1.375;
      case 3:
        return 1.55;
      case 4:
        return 1.725;
      case 5:
        return 1.9;
      default:
        return 1.55;
    }
  }

  double calcDailyCalories() {
    return getBMR() * getTEE();
  }

  void showCalculator(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: AlertDialog(
                title: Text("Calculate your limits"),
                content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Sex:"),
                          DropdownButton(
                              value: sex,
                              items: [
                                DropdownMenuItem(
                                  child: Text("Male"),
                                  value: "male",
                                ),
                                DropdownMenuItem(
                                  child: Text("Female"),
                                  value: "female",
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  sex = value;
                                });
                              }
                          ),
                          Text("Activity Level:"),
                          DropdownButton(
                              value: energy_expenditure,
                              items: [
                                DropdownMenuItem(
                                  child: Text("None"),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child: Text("Light"),
                                  value: 2,
                                ),
                                DropdownMenuItem(
                                  child: Text("Moderate"),
                                  value: 3,
                                ),
                                DropdownMenuItem(
                                  child: Text("Heavy"),
                                  value: 4,
                                ),
                                DropdownMenuItem(
                                  child: Text("Very Heavy"),
                                  value: 5,
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  energy_expenditure = value;
                                });
                              }
                          ),
                          Text("Weight in pounds:"),
                          TextField(
                            keyboardType: TextInputType.number,
                            controller: weightController,
                          ),
                          Text("Height in inches:"),
                          TextField(
                            keyboardType: TextInputType.number,
                            controller: heightController,
                          ),
                          Text("Age:"),
                          TextField(
                            keyboardType: TextInputType.number,
                            controller: ageController,
                          ),
                        ],
                      );
                    }
                ),
                actions: <Widget> [
                  ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text("back")
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          weight_lb = int.parse(weightController.text);
                          height_in = int.parse(heightController.text);
                          age = int.parse(ageController.text);
                        });

                        double calcCalories = calcDailyCalories().roundToDouble();
                        double ratio = calcCalories / 2000;

                        double calcProtein = (50 * ratio).roundToDouble();
                        double calcSodium = (2300 * ratio).roundToDouble();
                        double calcCarbs = (275 * ratio).roundToDouble();
                        double calcFats = (78 * ratio).roundToDouble();
                        double calcSugar = (50 * ratio).roundToDouble();

                        await setLimit("calorie", calcCalories);
                        await setLimit("protein", calcProtein);
                        await setLimit("carbs", calcCarbs);
                        await setLimit("sodium", calcSodium);
                        await setLimit("fats", calcFats);
                        await setLimit("sugar", calcSugar);

                        setState(() {
                          //reload page
                        });

                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.check)
                  )
                ]
            ),
          );
        }
    );
  }

  Container createInfoWidget(IconData i, String name, int amount) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
              i,
              size: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
            ),
          ),
          Text(
            amount.toString()
          )
        ],
      )
    );
  }

  Widget progressBar(DataLimit dL)
  {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              dL.label+": " + dL.at.toString() + "/" + dL.limit.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
          ),
        ),
        StepProgressIndicator(
          totalSteps: dL.limit.toInt(),
          currentStep: min(dL.at.toInt(), dL.limit.toInt()),
          size: 8,
          padding: 0,
          selectedGradientColor: LinearGradient(
            colors: [Colors.greenAccent, Colors.green,]
          ),
          unselectedColor: Colors.white,
          roundedEdges: Radius.circular(10),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    getLimits(LIMITS.keys.toList());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height*0.15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: Text(
                        "FOOD SYNC",
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                        ),
                    ),
                  ),
                ],
              )
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      gradient: FlutterGradients.grownEarly()
                    ),
                  ),
                ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10, left: 0,right: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            style: AppColors.buttonStyle,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Scanning(cameras)),
                              );
                            },
                            child: Text("Scan")
                        ),
                        ElevatedButton(
                            style: AppColors.buttonStyle,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => History()),
                              );
                            },
                            child: Text("History")
                        ),
                        ElevatedButton(
                            style: AppColors.buttonStyle,
                            onPressed: () {
                              showLimitEditor(context);
                            },
                            child: Text("Limits")
                        ),
                        ElevatedButton(
                            style: AppColors.buttonStyle,
                            onPressed: () {
                              showCalculator(context);
                            },
                            child: Text("Calculate")
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            flex: 30,
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 17,
              mainAxisSpacing: 17,
              crossAxisCount: 3,
              children: <Widget>[
                createInfoWidget(Icons.cake, "Sugar", 36),
                createInfoWidget(Icons.local_pizza, "Sodium", 2300),
                createInfoWidget(Icons.set_meal, "Protein", 60),
                createInfoWidget(Icons.dangerous, "Fats", 97),
                createInfoWidget(Icons.food_bank, "Carbs", 275),
                createInfoWidget(Icons.fastfood_sharp, "Calories", 2000),
              ],
            ),
          ),
          Expanded(
            flex: 40,
            child: ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: limits.length,
                itemBuilder: (BuildContext context, int index) {
                  return progressBar(limits[index]);
                }
            )
          )
        ],
      ),
    );
  }
}
