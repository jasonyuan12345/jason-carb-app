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
  "Avocado" :FoodData("Avocado", 200, 3, 11, 13, 22, 0.66),
  "Bacon" :FoodData("Bacon", 43, 3, 137, 0.1, 3.3,0 ),
  "Lamb" :FoodData("Lamb", 250, 21, 61, 0, 18, 0),
  "Steak" :FoodData("Steak", 679, 62, 146, 0, 48, 0),
  "Pork" :FoodData("Pork", 206, 23, 53, 0, 12, 0),
  "Cucumber" :FoodData("Cucumber", 30, 3, 2.8, 1.9, 0, 1.7),
  "Fried Chicken" :FoodData("Fried Chicken", 320, 40, 100, 2.4, 16, 0),
  "Hot Dog" :FoodData("Hot Dog", 151, 5, 567, 2.2, 13, 0),
  "Cookies" :FoodData("Cookies", 142, 1.7, 149, 18, 7, 4.3),
  "Fried Rice" :FoodData("Fried Rice", 228, 7, 554, 43, 3.2, 0.6),
  "Pizza" :FoodData("Pizza", 285, 7, 640, 36, 10, 3.8),
  "Waffles" :FoodData("Waffles", 82, 2.2, 145, 9, 4, 3.3),
};
