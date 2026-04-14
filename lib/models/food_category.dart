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
  FoodCategory(
    economyClass,
    5,
    'https://images.unsplash.com/photo-1494976388531-d1058494cdd8'
        '?auto=format&fit=crop&w=900&q=80',
  ),
  FoodCategory(
    comfortClass,
    5,
    'https://images.unsplash.com/photo-1549399542-7e3f8b79c341'
        '?auto=format&fit=crop&w=900&q=80',
  ),
  FoodCategory(
    premiumClass,
    5,
    'https://images.unsplash.com/photo-1556189250-72ba954cfc2b'
        '?auto=format&fit=crop&w=900&q=80',
  ),
  FoodCategory(
    electricClass,
    5,
    'https://images.unsplash.com/photo-1560958089-b8a1929cea89'
        '?auto=format&fit=crop&w=900&q=80',
  ),
];
