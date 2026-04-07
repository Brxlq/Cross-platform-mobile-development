class Post {
  Post(
    this.id,
    this.profileImageUrl,
    this.comment,
    this.timestamp,
  );

  String id;
  String profileImageUrl;
  String comment;
  String timestamp;
}

List<Post> posts = [
  Post(
    '1',
    'assets/profile_pics/person_cesare.jpeg',
    'Took the Tesla Model 3 across downtown and still had '
        '62% battery left after meetings.',
    '10',
  ),
  Post(
    '2',
    'assets/profile_pics/person_stef.jpeg',
    'Weekend mountain run in the Honda Accord felt smooth even in the rain.',
    '80',
  ),
  Post(
    '3',
    'assets/profile_pics/person_crispy.png',
    'Airport pickup with the Toyota Corolla was cheaper '
        'than rideshare both ways.',
    '20',
  ),
  Post(
    '4',
    'assets/profile_pics/person_joe.jpeg',
    'Booked an extra driver pass and swapped at the coast '
        'without any friction.',
    '30',
  ),
  Post(
    '5',
    'assets/profile_pics/person_katz.jpeg',
    'The in-app unlock is fast enough that I barely stop walking now.',
    '40',
  ),
  Post(
    '6',
    'assets/profile_pics/person_kevin.jpeg',
    'Charging stops were already mapped for the whole road trip. '
        'Very good touch.',
    '50',
  ),
  Post(
    '7',
    'assets/profile_pics/person_sandra.jpeg',
    'Used Echelon for a client day and skipped renting '
        'from the airport counter entirely.',
    '50',
  ),
];
