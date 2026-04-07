import 'food_category.dart';

class Item {
  Item({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  final String name;
  final String description;
  final double price;
  final String imageUrl;
}

class Restaurant {
  Restaurant(
    this.id,
    this.name,
    this.address,
    this.attributes,
    this.imageUrl,
    this.imageCredits,
    this.distance,
    this.rating,
    this.items, {
    required this.vehicleClass,
    required this.hourlyRate,
  });

  String id;
  String name;
  String address;
  String attributes;
  String imageUrl;
  String imageCredits;
  double distance;
  double rating;
  List<Item> items;
  String vehicleClass;
  double hourlyRate;

  double get dailyRate => hourlyRate * 8;

  String getRatingAndDistance() {
    return 'Rated ${rating.toStringAsFixed(1)} | '
        '${distance.toStringAsFixed(1)} mi away';
  }

  String get priceLabel => '\$${hourlyRate.toStringAsFixed(0)}/hr';
}

List<Item> economyAddOns() {
  return [
    Item(
      name: 'Phone mount and cable pack',
      description:
          'Magnetic dash mount with Lightning and USB-C charging cables.',
      price: 8,
      imageUrl:
          'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9'
          '?auto=format&fit=crop&w=900&q=80',
    ),
    Item(
      name: 'Street parking protection',
      description: 'Reduced excess for mirrors, scrapes, and wheel damage.',
      price: 14,
      imageUrl:
          'https://images.unsplash.com/photo-1503736334956-4c8f8e92946d'
          '?auto=format&fit=crop&w=900&q=80',
    ),
  ];
}

List<Item> comfortAddOns() {
  return [
    Item(
      name: 'Extra driver access',
      description:
          'Add a second approved driver for city handoffs '
          'or longer day trips.',
      price: 18,
      imageUrl:
          'https://images.unsplash.com/photo-1503376780353-7e6692767b70'
          '?auto=format&fit=crop&w=900&q=80',
    ),
    Item(
      name: 'Unlimited local miles',
      description:
          'Upgrade your booking with unlimited mileage in the local zone.',
      price: 20,
      imageUrl:
          'https://images.unsplash.com/photo-1485291571150-772bcfc10da5'
          '?auto=format&fit=crop&w=900&q=80',
    ),
  ];
}

List<Item> premiumAddOns() {
  return [
    Item(
      name: 'Concierge detail',
      description:
          'Fresh wash, cabin fragrance reset, and premium curb presentation.',
      price: 26,
      imageUrl:
          'https://images.unsplash.com/photo-1607861716497-e65ab29fc7ac'
          '?auto=format&fit=crop&w=900&q=80',
    ),
    Item(
      name: 'Valet return',
      description:
          'End your trip in the core service zone without '
          'returning to the hub.',
      price: 30,
      imageUrl:
          'https://images.unsplash.com/photo-1503736334956-4c8f8e92946d'
          '?auto=format&fit=crop&w=900&q=80',
    ),
  ];
}

List<Item> electricAddOns() {
  return [
    Item(
      name: 'Supercharger credit',
      description:
          'Prepaid fast-charging credit for quick top-ups during the trip.',
      price: 12,
      imageUrl:
          'https://images.unsplash.com/photo-1593941707882-a5bac6861d75'
          '?auto=format&fit=crop&w=900&q=80',
    ),
    Item(
      name: 'Airport lane pass',
      description: 'Priority pickup and drop-off access for major terminals.',
      price: 24,
      imageUrl:
          'https://images.unsplash.com/photo-1436491865332-7a61a109cc05'
          '?auto=format&fit=crop&w=900&q=80',
    ),
  ];
}

List<Restaurant> restaurants = [
  Restaurant(
    '0',
    'Toyota Corolla',
    'Khan Shatyr Hub, Astana',
    'Economy, fuel efficient, Apple CarPlay',
    'https://images.unsplash.com/photo-1623869675781-80aa31012a5a?q=80&w=1154&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
        '?auto=format&fit=crop&w=1400&q=80',
    'https://images.unsplash.com/photo-1623869675781-80aa31012a5a?q=80&w=1154&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    0.8,
    4.7,
    economyAddOns(),
    vehicleClass: economyClass,
    hourlyRate: 14,
  ),
  Restaurant(
    '1',
    'Hyundai Elantra',
    'Nurzhol Boulevard Hub, Astana',
    'Economy, efficient commuter, easy parking',
    'https://images.unsplash.com/photo-1724217557820-8630c9844cfb?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
        '?auto=format&fit=crop&w=1400&q=80',
    'https://images.unsplash.com/photo-1724217557820-8630c9844cfb?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    1.3,
    4.6,
    economyAddOns(),
    vehicleClass: economyClass,
    hourlyRate: 13,
  ),
  Restaurant(
    '2',
    'Kia Rio',
    'Esil Riverside Hub, Astana',
    'Economy, compact size, city-friendly',
    'https://images.unsplash.com/photo-1592805723127-004b174a1798?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
        '?auto=format&fit=crop&w=1400&q=80',
    'https://images.unsplash.com/photo-1592805723127-004b174a1798?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    1.0,
    4.5,
    economyAddOns(),
    vehicleClass: economyClass,
    hourlyRate: 12,
  ),
  Restaurant(
    '3',
    'Nissan Versa',
    'Abu Dhabi Plaza Hub, Astana',
    'Economy, practical trunk, smooth commuter',
    'https://hips.hearstapps.com/hmg-prod/images/2015-nissan-versa-note-sr-mmp-1-1557254081.jpg'
        '?auto=format&fit=crop&w=1400&q=80',
    'https://hips.hearstapps.com/hmg-prod/images/2015-nissan-versa-note-sr-mmp-1-1557254081.jpg',
    1.6,
    4.5,
    economyAddOns(),
    vehicleClass: economyClass,
    hourlyRate: 12,
  ),
  Restaurant(
    '4',
    'Chevrolet Spark',
    'Astana Opera Hub, Astana',
    'Economy, tiny footprint, easy curb parking',
    'https://imgcdn.zigwheels.us/large/gallery/exterior/7/58/chevrolet-spark-front-angle-low-view-603309.jpg'
        '?auto=format&fit=crop&w=1400&q=80',
    'https://imgcdn.zigwheels.us/large/gallery/exterior/7/58/chevrolet-spark-front-angle-low-view-603309.jpg',
    0.9,
    4.4,
    economyAddOns(),
    vehicleClass: economyClass,
    hourlyRate: 11,
  ),
  Restaurant(
    '5',
    'Honda Accord',
    'Baiterek Tower Hub, Astana',
    'Comfort, roomy cabin, adaptive cruise',
    'https://images.unsplash.com/photo-1634737581963-5a22ba471961?q=80&w=1243&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
        '?auto=format&fit=crop&w=1400&q=80',
    'https://images.unsplash.com/photo-1634737581963-5a22ba471961?q=80&w=1243&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    1.1,
    4.8,
    comfortAddOns(),
    vehicleClass: comfortClass,
    hourlyRate: 19,
  ),
  Restaurant(
    '6',
    'Toyota Camry',
    'EXPO Business Hub, Astana',
    'Comfort, quiet ride, ideal for longer city drives',
    'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
        '?auto=format&fit=crop&w=1400&q=80',
    'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    1.7,
    4.7,
    comfortAddOns(),
    vehicleClass: comfortClass,
    hourlyRate: 18,
  ),
  Restaurant(
    '7',
    'Mazda 6',
    'Botanical Garden Hub, Astana',
    'Comfort, refined steering, upscale cabin',
    'https://images.unsplash.com/photo-1658662160331-62f7e52e63de?q=80&w=1171&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
        '?auto=format&fit=crop&w=1400&q=80',
    'https://images.unsplash.com/photo-1658662160331-62f7e52e63de?q=80&w=1171&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    1.4,
    4.7,
    comfortAddOns(),
    vehicleClass: comfortClass,
    hourlyRate: 20,
  ),
  Restaurant(
    '8',
    'Nissan Altima',
    'Mega Silk Way Hub, Astana',
    'Comfort, balanced ride, spacious seats',
    'https://images.unsplash.com/photo-1581540222194-0def2dda95b8?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
        '?auto=format&fit=crop&w=1400&q=80',
    'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    1.2,
    4.6,
    comfortAddOns(),
    vehicleClass: comfortClass,
    hourlyRate: 18,
  ),
  Restaurant(
    '9',
    'Volkswagen Passat',
    'Saryarka Avenue Hub, Astana',
    'Comfort, smooth highway ride, large trunk',
    'https://images.unsplash.com/photo-1672052495056-2b55c254a776?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
        '?auto=format&fit=crop&w=1400&q=80',
    'https://images.unsplash.com/photo-1672052495056-2b55c254a776?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    1.8,
    4.6,
    comfortAddOns(),
    vehicleClass: comfortClass,
    hourlyRate: 17,
  ),
  Restaurant(
    '10',
    'BMW 5 Series',
    'Nazarbayev Center Hub, Astana',
    'Premium, leather cabin, executive ride',
    'https://images.unsplash.com/photo-1603386329225-868f9b1ee6c9'
        '?auto=format&fit=crop&w=1400&q=80',
    'https://images.unsplash.com/photo-1603386329225-868f9b1ee6c9',
    2.1,
    4.9,
    premiumAddOns(),
    vehicleClass: premiumClass,
    hourlyRate: 34,
  ),
  Restaurant(
    '11',
    'Mercedes-Benz E-Class',
    'Ak Orda District Hub, Astana',
    'Premium, smooth suspension, quiet cabin',
    'https://images.unsplash.com/photo-1700183422484-77641f4d2f3b?q=80&w=1172&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
        '?auto=format&fit=crop&w=1400&q=80',
    'https://images.unsplash.com/photo-1700183422484-77641f4d2f3b?q=80&w=1172&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    1.9,
    4.9,
    premiumAddOns(),
    vehicleClass: premiumClass,
    hourlyRate: 38,
  ),
  Restaurant(
    '12',
    'Audi A6',
    'Turan Avenue Hub, Astana',
    'Premium, quattro stability, executive comfort',
    'https://images.unsplash.com/photo-1652254186893-c597d354b9f6?q=80&w=1169&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
        '?auto=format&fit=crop&w=1400&q=80',
    'https://images.unsplash.com/photo-1652254186893-c597d354b9f6?q=80&w=1169&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    1.5,
    4.8,
    premiumAddOns(),
    vehicleClass: premiumClass,
    hourlyRate: 36,
  ),
  Restaurant(
    '13',
    'Lexus ES',
    'Qabanbay Batyr Avenue Hub, Astana',
    'Premium, soft ride, quiet interior',
    'https://images.unsplash.com/photo-1615106806531-183c31fccfdc?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
        '?auto=format&fit=crop&w=1400&q=80',
    'https://images.unsplash.com/photo-1615106806531-183c31fccfdc?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    2.0,
    4.8,
    premiumAddOns(),
    vehicleClass: premiumClass,
    hourlyRate: 35,
  ),
  Restaurant(
    '14',
    'Volvo S90',
    'Triumphal Arch Hub, Astana',
    'Premium, Scandinavian design, pilot assist',
    'https://images.unsplash.com/photo-1629896428945-349a9a86e6ba?q=80&w=1174&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
        '?auto=format&fit=crop&w=1400&q=80',
    'https://images.unsplash.com/photo-1629896428945-349a9a86e6ba?q=80&w=1174&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    2.3,
    4.7,
    premiumAddOns(),
    vehicleClass: premiumClass,
    hourlyRate: 33,
  ),
  Restaurant(
    '15',
    'Tesla Model 3',
    'Green Quarter Hub, Astana',
    'Electric, autopilot, fast charging',
    'https://images.unsplash.com/photo-1560958089-b8a1929cea89?q=80&w=1171&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
        '?auto=format&fit=crop&w=1400&q=80',
    'https://images.unsplash.com/photo-1560958089-b8a1929cea89?q=80&w=1171&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    0.5,
    4.8,
    electricAddOns(),
    vehicleClass: electricClass,
    hourlyRate: 27,
  ),
  Restaurant(
    '16',
    'Polestar 2',
    'Astana IT University Hub, Astana',
    'Electric, Scandinavian interior, one-pedal drive',
    'https://images.unsplash.com/photo-1655287790092-c8e16d0ce24c?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
        '?auto=format&fit=crop&w=1400&q=80',
    'https://images.unsplash.com/photo-1655287790092-c8e16d0ce24c?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    0.9,
    4.8,
    electricAddOns(),
    vehicleClass: electricClass,
    hourlyRate: 29,
  ),
  Restaurant(
    '17',
    'Hyundai Ioniq 5',
    'EXPO Charging Hub, Astana',
    'Electric, ultra-fast charging, spacious cabin',
    'https://images.unsplash.com/photo-1647934441921-4ed1e182e4b3?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
        '?auto=format&fit=crop&w=1400&q=80',
    'https://images.unsplash.com/photo-1619767886558-efdc259cde1a?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    1.0,
    4.9,
    electricAddOns(),
    vehicleClass: electricClass,
    hourlyRate: 28,
  ),
  Restaurant(
    '18',
    'Kia EV6',
    'Astana Arena Hub, Astana',
    'Electric, sporty response, rapid charging',
    'https://images.unsplash.com/photo-1710292739436-233fc0a8c2ea?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
        '?auto=format&fit=crop&w=1400&q=80',
    'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    1.2,
    4.8,
    electricAddOns(),
    vehicleClass: electricClass,
    hourlyRate: 28,
  ),
  Restaurant(
    '19',
    'BMW i4',
    'Nazarbayev University Hub, Astana',
    'Electric, premium interior, grand touring feel',
    'https://images.unsplash.com/photo-1665950799673-5819ddf77750?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
        '?auto=format&fit=crop&w=1400&q=80',
    'https://images.unsplash.com/photo-1553440569-bcc63803a83d?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    1.6,
    4.9,
    electricAddOns(),
    vehicleClass: electricClass,
    hourlyRate: 32,
  ),
];
