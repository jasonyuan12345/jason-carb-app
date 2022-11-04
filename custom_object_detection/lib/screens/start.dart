import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tflite_test/screens/history.dart';
import 'package:tflite_test/screens/home_page.dart';

import '../main.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {

  Container createInfoWidget(IconData i, String name, int amount) {
    return Container(
      color: Colors.white,
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
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height*0.20,
              child: Center(
                child: Text(
                    "APP NAME",
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 30
                    ),
                ),
              )
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
          Expanded(
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
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
          )
        ],
      ),
    );
  }
}
