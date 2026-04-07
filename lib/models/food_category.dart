class FoodCategory {
  FoodCategory(this.name, this.numberOfRestaurants, this.imageUrl);

  String name;
  int numberOfRestaurants;
  String imageUrl;
}

const String economyClass = 'Economy';
const String comfortClass = 'Comfort';
const String premiumClass = 'Premium';
const String electricClass = 'Electric';

List<FoodCategory> categories = [
  FoodCategory(economyClass, 5, ''),
  FoodCategory(comfortClass, 5, ''),
  FoodCategory(premiumClass, 5, ''),
  FoodCategory(electricClass, 5, ''),
];
