import 'package:carb_app/FoodDictionary.dart';
import 'package:carb_app/SecondScreen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("wadwad"),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 25,
              child: Image(
                  image: NetworkImage("https://media.istockphoto.com/vectors/simple-apple-in-flat-style-vector-illustration-vector-id1141529240?k=20&m=1141529240&s=612x612&w=0&h=_j9z-sPT6AqFDSSXHnSYWrXOvDOgyMmSdTUrBiZULCo=")
              ),
            ),
            Expanded(
              flex: 75,
              child: Column(
                children: [
                  Text(" Title "),
                  ElevatedButton(onPressed: () {
                    var push = Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SecondScreen()),
                    );
                  }, child: Text("Title"),)
                ],
              )
            )
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FoodData? fD = foodDictionary["Apple"];
          print(fD?.name);
          print(fD?.calories);
        },
        child: Icon(Icons.apple),
      ),
    );
  }
}
