class FoodData {
  String name;
  int calories;
  double protein;
  double sodium;
  double carbs;
  double fats;

  FoodData(this.name, this.calories, this.protein, this.sodium, this.carbs, this.fats);
}

Map<String, FoodData> foodDictionary = {
  "Apple" : FoodData("Apple", 10, 11, 12, 13, 14),
};