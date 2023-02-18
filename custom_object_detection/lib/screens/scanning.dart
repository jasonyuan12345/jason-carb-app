import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:tflite/tflite.dart';
import 'package:tflite_test/screens/camera.dart';

import '../food_dictionary.dart';

class Scanning extends StatefulWidget {
  final List<CameraDescription> cameras;

  Scanning(this.cameras);
  @override
  _ScanningState createState() => _ScanningState();
}

class _ScanningState extends State<Scanning> {
  List<dynamic> output = [];
  bool showWarning = false;

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

        for(int i = 0; i<outputs.length; i++) {
          print(outputs[i]["label"]);
          FoodData fD = getCorrespondingFoodInfo(outputs[i]["label"]);

          if (fD.calories > 450 ||
              fD.sugar > 30 ||
              fD.carbs > 48 ||
              fD.sodium > 200 ||
              fD.fats > 35) {
            showWarning = true;
            break;
          } else {
            showWarning = false;
          }
        }
      });
    }
  }

  FoodData getCorrespondingFoodInfo(String l) {
    switch(l) {
      case "0 Banana":
        return foodDictionary["Banana"];
      case "1 Orange":
        return foodDictionary["Orange"];
      case "2 Kiwi":
        return foodDictionary["Kiwi"];
      case "3 Dragonfruit":
        return foodDictionary["Dragonfruit"];
      case "4 Mango":
        return foodDictionary["Mango"];
      case "5 Apple":
        return foodDictionary["Apple"];
      case "6 Cookies":
        return foodDictionary["Cookies"];
      case "7 Chocolate":
        return foodDictionary["Chocolate"];
      case "8 Cucumber":
        return foodDictionary["Cucumber"];
      case "9 Donuts":
        return foodDictionary["Donuts"];
      case "10 Baked Beans":
        return foodDictionary["Baked Beans"];
      case "11 Popcorn":
        return foodDictionary["Popcorn"];
      case "12 Potato Chips":
        return foodDictionary["Potato Chips"];
      case "13 Avocado":
        return foodDictionary["Avocado"];
      case "14 Bacon":
        return foodDictionary["Bacon"];
      case "15 Barbecue Ribs":
        return foodDictionary["Barbecue Ribs"];
      case "16 Buffalo Wings":
        return foodDictionary["Buffalo Wings"];
      case "17 Fried Rice":
        return foodDictionary["Fried Rice"];
      case "18 Pork":
        return foodDictionary["Pork"];
      case "19 Salad":
        return foodDictionary["Salad"];
      case "20 Sushi":
        return foodDictionary["Sushi"];
      case "21 Pho":
        return foodDictionary["Pho"];
      case "22 Pizza":
        return foodDictionary["Pizza"];
      case "23 Ice Cream":
        return foodDictionary["Ice Cream"];
      case "24 Waffles":
        return foodDictionary["Waffles"];
      case "25 Tacos":
        return foodDictionary["Tacos"];
      case "26 Macaroni and Cheese":
        return foodDictionary["Macaroni and Cheese"];
      case "27 Oyster":
        return foodDictionary["Oyster"];
      case "28 Pancakes":
        return foodDictionary["Pancakes"];
      case "29 Pickles":
        return foodDictionary["Pickles"];
      case "30 Sausage":
        return foodDictionary["Sausage"];
      case "31 Sodas":
        return foodDictionary["Sodas"];
      case "32 Toast":
        return foodDictionary["Toast"];
      case "33 Tofu":
        return foodDictionary["Tofu"];
      case "34 Apple Pie":
        return foodDictionary["Apple Pie"];
      case "35 Broccoli":
        return foodDictionary["Broccoli"];
      case "36 Coconut":
        return foodDictionary["Coconut"];
      case "37 Coffee":
        return foodDictionary["Coffee"];
      case "38 Mushrooms":
        return foodDictionary["Mushrooms"];
      case "39 Onions":
        return foodDictionary["Onions"];
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
    else
      warnings.add("${calorieLimit - calories} calories left until you reach your limit!");

    if (protein > proteinLimit)
      warnings.add("You have exceeded your protein limit by " + (protein-proteinLimit).toString());
    else
      warnings.add("${proteinLimit - protein} grams left until you reach your limit!");

    if (sodium > sodiumLimit)
      warnings.add("You have exceeded your sodium limit by " + (sodium-sodiumLimit).toString());
    else
      warnings.add("${sodiumLimit - sodium} milligrams of sodium left until you reach your limit!");

    if (carbs > carbsLimit)
      warnings.add("You have exceeded your carbs limit by " + (carbs-carbsLimit).toString());
    else
      warnings.add("${carbsLimit - carbs} grams of carbs left until you reach your limit!");

    if (fats > fatsLimit)
      warnings.add("You have exceeded your fats limit by " + (fats-fatsLimit).toString());
    else
      warnings.add("${fatsLimit - fats} grams of fat left until you reach your limit!");

    if (sugar > sugarLimit)
      warnings.add("You have exceeded your sugar limit by " + (sugar-sugarLimit).toString());
    else
      warnings.add("${sugarLimit - sugar} grams of sugar left until you reach your limit!");

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
            "• " + s,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white
            ),
        )
      );
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[800].withOpacity(0.7),
              title: Text("Good work!",
              style: TextStyle(
                color: Colors.white
              ),),
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
    TextStyle tS = TextStyle(
      fontSize: 20,
      color: Colors.white,
      fontWeight: FontWeight.bold
    );

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.grey[800],
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.6,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only( top:25, bottom: 15 ),
                  child: Text(
                      fD.name,
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only( top:10 ),
                  child: Text(
                      "Calories: " + fD.calories.toString() + "C",
                      style: tS,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only( top:10 ),
                  child: Text(
                      "Protein: " + fD.protein.toString() + "g",
                      style: tS,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only( top:10 ),
                  child: Text(
                      "Fats: "+ fD.fats.toString() + "g",
                    style: tS,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only( top:10 ),
                  child: Text(
                      "Sodium: "+ fD.sodium.toString() + "mg",
                    style: tS,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only( top:10 ),
                  child: Text(
                      "Carbs: "+ fD.carbs.toString() + "g",
                    style: tS,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only( top:10 ),
                  child: Text(
                      "Sugar: "+ fD.sugar.toString() + "g",
                    style: tS,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ElevatedButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          child: Text(
                              "back",
                              style: tS,
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          List<String> goals = await saveToFoodHistory(fD.name);
                          if (goals.isNotEmpty)
                            await saveWarnings(goals);
                          Navigator.of(context).pop();
                          showLimitReached(goals, context);
                        },
                        child: Text(
                          "add",
                          style: tS,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text("Scanning"),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.green,
      ),
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Camera(widget.cameras, setRecognitions),

          (output.length == 0)?
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                     color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(50))
                  ),
                  child: Text(
                    "Scanning for items...",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black
                    ),
                  ),
                ),
              )
          :ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: output.length,
            itemBuilder: (BuildContext context, int index) {
               //turn the label "0 Banana" into "Banana"
               RegExp re = RegExp(r'[a-zA-Z]*$');
               String label = output[index]["label"].toString();
               Match m = re.firstMatch(label);
               String displayString = label.substring(m.start, m.end);


               return Padding(
                 padding: const EdgeInsets.only(
                   left: 40,
                   top: 10,
                   right: 40,
                   bottom: 20,
                 ),
                 child: Container(
                   decoration: BoxDecoration(
                     color: Colors.grey[800].withOpacity(0.7),
                     borderRadius: BorderRadius.all(Radius.circular(50))
                   ),
                   height: 50,
                   width: 200,
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         Text(
                           displayString,
                           style: TextStyle(
                             fontSize: 20,
                             fontWeight: FontWeight.bold,
                             color: Colors.white
                           ),
                         ),
                         IconButton(
                             onPressed: () {
                               showFoodInfo(output[index]["label"], context);
                             },
                             icon: Icon(
                                 Icons.add,
                                 color: Colors.white,
                             )
                         )
                       ],
                     ),
                   ),
                 ),
               );
            }
          ),
          showWarning?
            Center(
                child: Opacity(
                    opacity: 0.5,
                    child: Container(
                        width: MediaQuery.of(context).size.width/2,
                        height: MediaQuery.of(context).size.width/2,
                        child: Image.network("https://www.pngkit.com/png/full/76-760200_big-red-x-red-x-mark-transparent-background.png")
                    )
                )
            ) :
            Center(
              child: Opacity(
                opacity: 0.5,
                child: Container(
                    width: MediaQuery.of(context).size.width/2,
                    height: MediaQuery.of(context).size.width/2,
                    child: Image.network("https://www.vippng.com/png/full/2-21068_tick-green-modern-green-correct-symbol-transparent-background.png")
                ),
              ),
            )  
        ],
      ),
    );
  }
}
