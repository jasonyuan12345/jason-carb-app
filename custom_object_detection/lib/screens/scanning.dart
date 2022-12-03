import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:tflite/tflite.dart';
import 'package:tflite_test/screens/camera.dart';

import '../food_dictionary.dart';

class MyHomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  MyHomePage(this.cameras);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> output = [];

  @override
  void initState() {
    super.initState();
    loadTfliteModel();
  }

  loadTfliteModel() async {
    String res;
    res = await Tflite.loadModel(
        model: "assets/model_unquant.tflite", labels: "assets/labels_unquant.txt");
    print(res);
  }

  setRecognitions(outputs) {
    print(outputs);

    if (mounted) {
      setState(() {
        output = outputs;
      });
    }
  }

  FoodData getCorrespondingFoodInfo(String l) {
    switch(l) {
      case "0 Banana":
        return foodDictionary["Banana"];
      case "1 Watermelon":
        return foodDictionary["Watermelon"];
      case "2 Peach":
        return foodDictionary["Peach"];
      case "3 Tomato":
        return foodDictionary["Tomato"];
      case "4 Pineapple":
        return foodDictionary["Pineapple"];
      case "5 Rice":
        return foodDictionary["Rice"];
      case "6 Fries":
        return foodDictionary["Fries"];
      case "7 Hamburger":
        return foodDictionary["Hamburger"];
      case "8 Egg":
        return foodDictionary["Egg"];
      case "9 Noodle":
        return foodDictionary["Noodle"];
      case "10 Avocado":
        return foodDictionary["10 Avocado"];
      case "11 Bacon":
        return foodDictionary["11 Bacon"];
      case "12 Lamb":
        return foodDictionary["12 Lamb"];
      case "13 Steak":
        return foodDictionary["13 Steak"];
      case "14 Pork":
        return foodDictionary["14 Pork"];
      case "15 Cucumber":
        return foodDictionary["15 Cucumber"];
      case "16 Fried Chicken":
        return foodDictionary["16 Fried Chicken"];
      case "17 Hot Dog":
        return foodDictionary["17 Hot Dog"];
      case "18 Cookies":
        return foodDictionary["18 Cookies"];
      case "19 Fried Rice":
        return foodDictionary["19 Fried Rice"];
      case "20 Pizza":
        return foodDictionary["20 Pizza"];
      case "21 Waffles":
        return foodDictionary["21 Waffles"];


    }
  }

  Future<void> recalculateFoodData(String date) async {
    double calories = 0;
    double protein = 0;
    double sodium = 0;
    double carbs = 0;
    double fats = 0;
    double sugar = 0;

    final prefs = await SharedPreferences.getInstance();
    List<String> foodsEaten_names = [];
    foodsEaten_names = await prefs.getStringList(date);
    for (var value in foodsEaten_names) {
      FoodData fD = foodDictionary[value];
      calories += fD.calories;
      protein += fD.protein;
      sodium += fD.sodium;
      carbs += fD.carbs;
      fats += fD.fats;
      sugar += fD.sugar;
    }

    await prefs.setDouble("calorieIntake", calories);
    await prefs.setDouble("sodiumIntake", sodium);
    await prefs.setDouble("carbsIntake", carbs);
    await prefs.setDouble("fatsIntake", fats);
    await prefs.setDouble("sugarIntake", sugar);
    await prefs.setDouble("proteinIntake", protein);
  }

  Future<List<String>> evaluateFoodData(String date) async {
    final prefs = await SharedPreferences.getInstance();
    double calorieLimit;
    double proteinLimit;
    double sodiumLimit;
    double carbsLimit;
    double fatsLimit;
    double sugarLimit;

    calorieLimit =  prefs.getDouble("calorieLimit");
    proteinLimit =  prefs.getDouble("proteinLimit");
    sodiumLimit =  prefs.getDouble("sodiumLimit");
    carbsLimit =  prefs.getDouble("carbsLimit");
    fatsLimit =  prefs.getDouble("fatsLimit");
    sugarLimit =  prefs.getDouble("sugarLimit");
    
    print(calorieLimit);
    print(proteinLimit);
    print(sodiumLimit);
    print(carbsLimit);
    print(fatsLimit);
    print(sugarLimit);

    double calories;
    double protein;
    double sodium;
    double carbs;
    double fats;
    double sugar;

    calories = prefs.getDouble("calorieIntake");
    protein = prefs.getDouble("proteinIntake");
    sodium = prefs.getDouble("sodiumIntake");
    carbs = prefs.getDouble("carbsIntake");
    fats = prefs.getDouble("fatsIntake");
    sugar = prefs.getDouble("sugarIntake");

    print(calories);
    print(protein);
    print(sodium);
    print(carbs);
    print(fats);
    print(sugar);

    List<String> warnings = [];

    if (calories > calorieLimit)
      warnings.add("You have exceeded your calories limit by " + (calories-calorieLimit).toString());
    if (protein > proteinLimit)
      warnings.add("You have exceeded your protein limit by " + (protein-proteinLimit).toString());
    if (sodium > sodiumLimit)
      warnings.add("You have exceeded your sodium limit by " + (sodium-sodiumLimit).toString());
    if (carbs > carbsLimit)
      warnings.add("You have exceeded your carbs limit by " + (carbs-carbsLimit).toString());
    if (fats > fatsLimit)
      warnings.add("You have exceeded your fats limit by " + (fats-fatsLimit).toString());
    if (sugar > sugarLimit)
      warnings.add("You have exceeded your sugar limit by " + (sugar-sugarLimit).toString());

    return warnings;
  }

  Future<void> saveWarnings(List<String> warnings) async
  {
    String today = DateTime.now().day.toString() + "/" + DateTime.now().month.toString() + "/" + DateTime.now().year.toString();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(today + " WARNINGS", warnings).
    then((value) {
      print("Set warnings for " + today);
    });
  }

  void showLimitReached(List<String> goals, BuildContext context) {
    List<Widget> goalWidgets = [];
    for (String s in goals) {
      goalWidgets.add(
        Text(
            s
        )
      );
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Good work!"),
            content: SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Divider(),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularStepProgressIndicator(
                                totalSteps: 100,
                                currentStep: 50,
                                width: 150,
                                height: 150,
                                selectedColor: Colors.green,
                                stepSize: 10,
                                roundedCap: (_, __) => true,
                                gradientColor: LinearGradient(
                                  colors: [Colors.blue, Colors.green]
                                ),
                              )
                            )
                    ),
                    Column(
                      children: goalWidgets,
                    )
                  ],
                ),
              ),
            ),
              actions: <Widget> [
                ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: Text("back")
                ),
              ]
          );
        }
    );
  }

  Future<List<String>> saveToFoodHistory(String name) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> foodsEaten = [];
    String today = DateTime.now().day.toString() + "/" + DateTime.now().month.toString() + "/" + DateTime.now().year.toString();
    print(today);

    //see if there's any food that was eaten today
    //if there is, then add yourself to that list
    if (prefs.containsKey(today))
      {
        foodsEaten = await prefs.getStringList(today);
        foodsEaten.add(name);
      }
    //if there isn't, make a new entry in shared preferences
    else {
      foodsEaten.add(name);
    }

    await prefs.setStringList(today, foodsEaten).
    then((value) {
      print("Saved " + name + " to " + today);
    }).
    catchError((error) {
      print(error.toString());
    });

    List<String> days = [];
    if (prefs.containsKey("days")) {
      print("Grabbing days...");
      days = await prefs.getStringList("days");
    }
    else {
      print("Creating new day list");
    }

    if (!days.contains(today)) days.add(today);
    print(days);
    await prefs.setStringList("days", days).
    then((value) {
      print("Saved " + today + " to days");
      print(days);
    }).
    catchError((error) {
      print(error.toString());
    });

    await recalculateFoodData(today);
    return await evaluateFoodData(today);
  }

  void showFoodInfo(String l, BuildContext context) {
    FoodData fD = getCorrespondingFoodInfo(l);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(fD.name),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Calories: " + fD.calories.toString() + "C"),
                Text("Protein: " + fD.protein.toString() + "g"),
                Text("Fats: "+ fD.fats.toString() + "g"),
                Text("Sodium: "+ fD.sodium.toString() + "mg"),
                Text("Carbs: "+ fD.carbs.toString() + "g"),
                Text("Sugar: "+ fD.sugar.toString() + "g"),
              ],
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
                    List<String> goals = await saveToFoodHistory(fD.name);
                    if (goals.isNotEmpty)
                      await saveWarnings(goals);
                      Navigator.of(context).pop();
                      showLimitReached(goals, context);
                    },
                  child: Text("add"),
              )
            ]
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Camera(widget.cameras, setRecognitions),
          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: output.length,
            itemBuilder: (BuildContext context, int index) {
               return Container(
                 height: 50,
                 color: Colors.amber,
                 child: Row(
                   children: [
                     Text(output[index]["label"]),
                     IconButton(
                         onPressed: () {
                           showFoodInfo(output[index]["label"], context);
                         },
                         icon: Icon(Icons.remove_red_eye))
                   ],
                 ),
               );
            }
          )
        ],
      ),
    );
  }
}
