import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tflite_test/screens/start.dart';
class History extends StatefulWidget {
  const History({Key key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  HashMap<String, List<String>> entries = new HashMap<String, List<String>>();
  List<Widget> selectedEntry = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  bool selectedDayWithFood = false;

  _HistoryState()
  {
    getAllFoodsEaten();
  }

  String dateTimeToSimpleString(DateTime dT)
  {
    return dT.day.toString() + "/" + dT.month.toString() + "/" + dT.year.toString();
  }

  bool isDayInEntries(String day)
  {
    return entries.containsKey(day);
  }

  Widget foodWidget(String food)
  {
    return Text(food);
  }

  Widget warningWidget(String warning)
  {
    return Container(
        color: Colors.red,
        child: Text
          (
            warning,
            style: TextStyle(
              color: Colors.white
            ),
          )
    );
  }

  void setSelectedDay(DateTime day) async
  {
    day = DateTime(day.year, day.month, day.day);
    print("Selected: " + day.toString());
    String dayString = dateTimeToSimpleString(day);

    if (entries[dayString] == null){
      selectedDayWithFood = false;
      selectedEntry.clear();
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    List<String> foods = List.from(entries[dayString]);
    selectedDayWithFood = isDayInEntries(dayString);

    if (selectedDayWithFood) {
      List<String> warnings = prefs.getStringList(dayString + " WARNINGS");
      if (warnings != null && warnings.isNotEmpty) {
        warnings.forEach((warning) {
          selectedEntry.add(warningWidget(warning));
        });
      }
    }
    else {
      print(day.toString() + " has no foods");
    }

    if (foods != null && foods.isNotEmpty) {
      foods.forEach((food) {
        selectedEntry.add(foodWidget(food));
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StartScreen()),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('TableCalendar - Basics'),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Expanded(
              flex: 50,
              child: TableCalendar(
                firstDay: DateTime.utc(2022, 11, 1),
                lastDay: DateTime.utc(2030, 12, 30),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  // Use `selectedDayPredicate` to determine which day is currently selected.
                  // If this returns true, then `day` will be marked as selected.

                  // Using `isSameDay` is recommended to disregard
                  // the time-part of compared DateTime objects.
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    // Call `setState()` when updating the selected day
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;

                      setSelectedDay(selectedDay);
                    });
                  }
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    // Call `setState()` when updating calendar format
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  // No need to call `setState()` here
                  _focusedDay = focusedDay;
                },
              ),
            ),
            Expanded(
              flex: 50,
              child: selectedDayWithFood?
              ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: selectedEntry.length,
                itemBuilder: (BuildContext context, int index) {
                  return selectedEntry[index];
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
              ) : Container()
            )
          ],
        ),
      ),
    );
  }
}
