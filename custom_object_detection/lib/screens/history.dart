import 'dart:collection';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tflite_test/food_dictionary.dart';
import 'package:tflite_test/main.dart';
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
  double calories, protein, fats, sodium, sugar, carbs;
  double calorieLimit, proteinLimit, fatLimit, sodiumLimit, sugarLimit, carbsLimit;
  bool exceedCalories = false, exceedProtein = false, exceedFats = false, exceedSodium = false, exceedSugar = false, exceedCarbs = false;
  final ScrollController _scrollController = ScrollController();

  _HistoryState()
  {
    getLimits();
    getAllFoodsEaten();
  }

  Future<void> getLimits()
  async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      calorieLimit = prefs.getDouble("calorieLimit");
      proteinLimit = prefs.getDouble("proteinLimit");
      fatLimit = prefs.getDouble("fatsLimit");
      sodiumLimit = prefs.getDouble("sodiumLimit");
      sugarLimit = prefs.getDouble("sugarLimit");
      carbsLimit = prefs.getDouble("carbsLimit");
    });
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
    print("FOODS: " + foods.toString());

    calories = 0;
    protein = 0;
    fats = 0;
    carbs = 0;
    sugar = 0;
    sodium = 0;
    for (String s in foods)
      {
        FoodData f = foodDictionary[s];
        setState(() {
          calories+=f.calories;
          protein+=f.protein;
          fats+=f.fats;
          carbs+=f.carbs;
          sugar+=f.sugar;
          sodium+=f.sodium;
        });
      }
    print("$calories $protein $fats $carbs $sugar $sodium");

    selectedDayWithFood = isDayInEntries(dayString);

    if (selectedDayWithFood) {
      List<String> warnings = prefs.getStringList(dayString + " WARNINGS");
      if (warnings != null && warnings.isNotEmpty) {
        warnings.forEach((warning) {
          setState(() {
            if (warning.contains("exceeded"))
            {
              if (warning.contains("calories"))
                exceedCalories = true;
              if (warning.contains("carbs"))
                exceedCarbs = true;
              if (warning.contains("sugar"))
                exceedSugar = true;
              if (warning.contains("protein"))
                exceedProtein = true;
              if (warning.contains("fats"))
                exceedFats = true;
              if (warning.contains("sodium"))
                exceedSodium = true;
            }
          });
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
          title: Text('History'),
          backgroundColor: Colors.green,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Expanded(
              flex: 60,
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
            BarChart(
              BarChartData(
                barTouchData: barTouchData,
                titlesData: titlesData,
                borderData: borderData,
                barGroups: barGroups,
                gridData: FlGridData(show: false),
                alignment: BarChartAlignment.spaceAround,
                maxY: 20,
              ),
            )
            /*
            ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: selectedEntry.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return selectedEntry[index];
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            ) */: Container()
          )
        ],
      ),
    )
    );
  }

  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      tooltipBgColor: Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 8,
      getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
          ) {
        return BarTooltipItem(
          rod.toY.round().toString(),
          const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Calories';
        break;
      case 1:
        text = 'Carbs';
        break;
      case 2:
        text = 'Sugar';
        break;
      case 3:
        text = 'Protein';
        break;
      case 4:
        text = 'Fats';
        break;
      case 5:
        text = 'Sodium';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );

  FlBorderData get borderData => FlBorderData(
    show: false,
  );

  LinearGradient get _barsGradient => const LinearGradient(
    colors: [
      Colors.lightBlueAccent,
      Colors.greenAccent,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  LinearGradient get _exceedGradient => const LinearGradient(
    colors: [
      Colors.red,
      Colors.orange,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  int barHeight = 19;
  List<BarChartGroupData> get barGroups => [
    BarChartGroupData(
      x: 0,
      barRods: [
        BarChartRodData(
          toY: min(calories/calorieLimit * barHeight, barHeight.toDouble()),
          gradient: exceedCalories? _exceedGradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 1,
      barRods: [
        BarChartRodData(
          toY: min(carbs/carbsLimit * barHeight, barHeight.toDouble()),
          gradient: exceedCarbs? _exceedGradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 2,
      barRods: [
        BarChartRodData(
          toY: min(sugar/sugarLimit * barHeight, barHeight.toDouble()),
          gradient: exceedSugar? _exceedGradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 3,
      barRods: [
        BarChartRodData(
          toY: min(protein/proteinLimit * barHeight, barHeight.toDouble()),
          gradient: exceedProtein? _exceedGradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 4,
      barRods: [
        BarChartRodData(
          toY: min(fats/fatLimit * barHeight, barHeight.toDouble()),
          gradient: exceedFats? _exceedGradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 5,
      barRods: [
        BarChartRodData(
          toY: min(sodium/sodiumLimit * barHeight, barHeight.toDouble()),
          gradient: exceedSodium? _exceedGradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    ),
  ];
}
