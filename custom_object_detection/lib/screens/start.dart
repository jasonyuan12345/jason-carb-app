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
        limits.add(new DataLimit(limit, at, q));
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

  void showLimitEditor(String type, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Set your limit"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: limitController,
                  )
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
                      await setLimit(type.toLowerCase(), double.parse(limitController.text));
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.check)
                )
              ]
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                i,
                size: 50,
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                  name
              ),
              Text(
                  amount.toString()
              ),
              IconButton(
                  onPressed: () {
                    showLimitEditor(name, context);
                  },
                  icon: Icon(Icons.search),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget progressBar(DataLimit dL)
  {
    return Column(
      children: [
        Text(
            dL.label+": " + dL.at.toString() + "/" + dL.limit.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20
            ),
        ),
        StepProgressIndicator(
          totalSteps: dL.limit.toInt(),
          currentStep: dL.at.toInt(),
          size: 8,
          padding: 0,
          selectedColor: Colors.yellow,
          roundedEdges: Radius.circular(10),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          Expanded(
            flex: 35,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30, left: 8, right: 8, bottom: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        gradient: FlutterGradients.grownEarly()
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Scanning",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 35,
                                          color: Colors.white,
                                        ),
                                    ),
                                    Text(
                                        "the best tool to keep track",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment:MainAxisAlignment.end ,
                            children: [
                              IconButton(
                                iconSize: 40,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MyHomePage(cameras)),
                                    );
                                  },
                                  icon: Icon(
                                      Icons.arrow_circle_right,
                                      color: Colors.white,
                                  )
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: AppColors.buttonStyle,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => History()),
                          );
                        },
                        child: Text("History")
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 40,
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(10),
              crossAxisSpacing: 17,
              mainAxisSpacing: 17,
              crossAxisCount: 3,
              children: <Widget>[
                createInfoWidget(Icons.cake, "Sugar", 36),
                createInfoWidget(Icons.add, "Sodium", 2300),
                createInfoWidget(Icons.set_meal, "Protein", 60),
                createInfoWidget(Icons.dangerous, "Fats", 97),
                createInfoWidget(Icons.add, "Carbs", 275),
                createInfoWidget(Icons.fastfood_sharp, "Calories", 2000),
              ],
            ),
          ),
          Expanded(
            flex: 40,
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
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
