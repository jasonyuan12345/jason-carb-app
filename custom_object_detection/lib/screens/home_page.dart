import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

    setState(() {
      output = outputs;
    });
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
    }
  }

  Future<void> saveToFoodHistory(String name) async {
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
      List<String> days = await prefs.getStringList("days");
      days.add(today);
    }
    else {
      days.add(today);
    }

    await prefs.setStringList("days", days).
    then((value) {
      print("Saved " + today + " to days");
    }).
    catchError((error) {
      print(error.toString());
    });
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
                Text("Sodium: "+ fD.sodium.toString() + "g"),
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
                    await saveToFoodHistory(fD.name);
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.check)
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
      body: Column(
        children: [
          Expanded(
              flex: 80,
              child: Camera(widget.cameras, setRecognitions)
          ),
          Expanded(
            flex: 20,
            child: ListView.builder(
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
            ),
          )

        ],
      ),
    );
  }
}
