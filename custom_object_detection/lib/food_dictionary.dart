class FoodData {
  String name;
  int calories;
  double protein;
  double sodium;
  double carbs;
  double fats;
  double sugar;

  FoodData(this.name, this.calories, this.protein, this.sodium, this.carbs, this.fats, this.sugar);
}

Map<String, FoodData> foodDictionary = {
  "Apple" : FoodData("Apple", 95, 0.5, 2, 25, 0.3, 19),
  "Banana" : FoodData("Banana", 105, 1.3, 1, 27, 0.4,14),
  "Peach" : FoodData("Peach", 50, 1, 0, 15, 0.5, 13),
  "Watermelon" : FoodData("Watermelon", 85, 1.7, 3, 21, 0.4, 17),
  "Tomato" :FoodData("Tomato", 22, 1.1, 6, 4.8, 0.2, 3),
  "Pineapple" :FoodData("Pineapple", 452, 4.9, 9, 119, 1.1, 89),
  "Rice" :FoodData("Rice", 206, 4.3, 2, 45, 0.4, 0.1),
  "Fries" :FoodData("Fries", 365, 4, 246, 48, 17, 0.4),
  "Hamburger" :FoodData("Hamburger", 354, 20, 497, 29, 17, 5),
  "Egg" :FoodData("Egg", 78, 6, 62, 0.6, 5, 0.6),
  "Noodle" :FoodData("Noodle", 221, 7, 8, 40, 3.3, 0.6),
};
