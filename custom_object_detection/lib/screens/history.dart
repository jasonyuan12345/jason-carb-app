import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class History extends StatefulWidget {
  const History({Key key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  HashMap<String, List<String>> entries = new HashMap<String, List<String>>();

  _HistoryState()
  {
    getAllFoodsEaten();
  }

  Future<void> getAllFoodsEaten() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> days = await prefs.getStringList("days");
    print("DAYS: " + days.toString());
    if (days == null) return;
    days.forEach((element) async {
      print(element);
      //get the list associated with that day
      //should be guaranteed to have some entry on that day
      List<String> foodsEatenOnDay = await prefs.getStringList(element);

      //add that list to your entries list
      setState(() {
        entries[element] = foodsEatenOnDay;
      });
    });
  }

  Column displayFoodsEaten(List<String> foods)
  {
    List<Text> foodsTexts = [];
    foods.forEach((element) {
      foodsTexts.add(Text(element));
    });
    
    return Column(
      children: foodsTexts
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
      ),
      body: Column(
        children: [
          if (entries == null)
            Text("No history of foods.")
          else
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: Colors.amber,
                  child: Column(
                    children: [
                      Text(entries.keys.elementAt(index)),
                      displayFoodsEaten(entries.values.elementAt(index))
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            ),
          )
        ],
      ),
    );
  }
}
