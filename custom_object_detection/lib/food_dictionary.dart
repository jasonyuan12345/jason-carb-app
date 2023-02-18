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
  "Banana" : FoodData("Banana", 105, 1.3, 1, 27, 0.4,14),
  "Orange" : FoodData("Orange", 47, 0.9, 0, 12, 0.1,9),
  "Kiwi" : FoodData("Kiwi", 61, 1.1, 3, 15, 0.5,9),
  "Dragonfruit" : FoodData("Dragonfruit", 102, 2, 0, 13, 0,8),
  "Mango" : FoodData("Mango", 60, 1, 1, 15, 0.4,14),
  "Apple" : FoodData("Apple", 95, 0.5, 2, 25, 0.3, 19),
  "Cookies" :FoodData("Cookies", 142, 1.7, 149, 18, 7, 4.3),
  "Chocolate" : FoodData("Chocolate", 546, 4.9, 24, 61, 31,48),
  "Cucumber" :FoodData("Cucumber", 30, 3, 2.8, 1.9, 0, 1.7),
  "Donuts" : FoodData("Donuts", 269, 4, 260, 25, 15,15),
  "Baked Beans" : FoodData("Baked Beans", 155, 6, 422, 22, 5,10),
  "Popcorn" : FoodData("Popcorn", 375, 11, 7, 74, 4.3,0.9),
  "Potato Chips" : FoodData("Potato Chips", 536, 7, 8, 53, 35,0.2),
  "Avocado" :FoodData("Avocado", 200, 3, 11, 13, 22, 0.66),
  "Bacon" :FoodData("Bacon", 43, 3, 137, 0.1, 3.3,0 ),
  "Barbecue Ribs" : FoodData("Barbecue Ribs", 108, 8.2, 234, 7, 5,6),
  "Fried Rice" :FoodData("Fried Rice", 228, 7, 554, 43, 3.2, 0.6),
  "Pork" :FoodData("Pork", 206, 23, 53, 0, 12, 0),
  "Salad" : FoodData("Salad", 100, 4, 280, 1.7, 0.13,8),
  "Sushi" : FoodData("Sushi", 150, 3, 200, 30, 0.11,13),
  "Pho" :FoodData("Pho", 400, 7, 1000, 19.5, 5.47, 5),
  "Pizza" :FoodData("Pizza", 285, 30, 640, 36, 10, 3.8),
  "Ice Cream" :FoodData("Ice Cream", 207, 3.5, 80, 24, 11, 21),
  "Waffles" :FoodData("Waffles", 1, 0.1, 2, 0, 0, 0),
  "Tacos" :FoodData("Tacos", 226, 9, 397, 20, 13, 0.9),
  "Macaroni and Cheese" :FoodData("Macaroni and Cheese", 164, 7, 460, 23, 5, 1.6),
  "Oyster" :FoodData("Oyster", 198, 9, 417, 12, 13, 2),
  "Pancakes" :FoodData("Pancakes", 227, 6, 439, 28, 10, 16),
  "Pickles" :FoodData("Pickles", 10, 0.3, 1208, 2.3, 0.2, 1.1),
  "Sausage" :FoodData("Sausage", 300, 12, 848, 2, 27, 0),
  "Sodas" :FoodData("Sodas", 41, 0, 4, 11, 0, 11),
  "Toast" :FoodData("Toast", 313, 13, 601, 56, 4.3, 6),
  "Tofu" :FoodData("Tofu", 76, 8, 7, 1.9, 4.8, 0.5),
  "Apple Pie" :FoodData("Apple Pie", 237, 1.9, 266, 34, 11, 17),
  "Broccoli" :FoodData("Broccoli", 34, 2.8, 33, 7, 0.4, 1.7),
  "Coconut" :FoodData("Coconut", 354, 3.3, 105, 15, 100, 6),
  "Coffee" :FoodData("Coffee", 1, 0.1, 2, 0, 0, 0),
  "Mushrooms" :FoodData("Mushrooms", 22, 3.1, 5, 3.3, 0.3, 2),
  "Onions" :FoodData("Onions", 40, 1.1, 4, 9, 0.1, 4.2),

  // "Watermelon" : FoodData("Watermelon", 85, 1.7, 3, 21, 0.4, 17),
  // "Peach" : FoodData("Peach", 50, 1, 0, 15, 0.5, 13),
  // "Buffalo Wing" : FoodData("Buffalo Wing", 441, 25.6, 1260, 0.2, 37,2),
  // "Tomato" :FoodData("Tomato", 22, 1.1, 6, 4.8, 0.2, 3),
  // "Pineapple" :FoodData("Pineapple", 452, 4.9, 9, 119, 1.1, 89),
  // "Rice" :FoodData("Rice", 206, 4.3, 2, 45, 0.4, 0.1),
  // "Fries" :FoodData("Fries", 365, 4, 246, 48, 17, 0.4),
  // "Hamburger" :FoodData("Hamburger", 354, 20, 497, 29, 17, 5),
  // "Egg" :FoodData("Egg", 78, 6, 62, 0.6, 5, 0.6),
  // "Noodle" :FoodData("Noodle", 221, 7, 8, 40, 3.3, 0.6),
  // "Lamb" :FoodData("Lamb", 250, 21, 61, 0, 18, 0),
  // "Steak" :FoodData("Steak", 679, 62, 146, 0, 48, 0),
  // "Fried Chicken" :FoodData("Fried Chicken", 320, 40, 100, 2.4, 16, 0),
  // "Hot Dog" :FoodData("Hot Dog", 151, 5, 567, 2.2, 13, 0),
  // "Pickles" :FoodData("Pickles", 10, 0.3, 1208, 2.3, 0.2, 1.1),
};
