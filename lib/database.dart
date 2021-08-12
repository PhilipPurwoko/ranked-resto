class Database {
  Database({required this.restaurants});

  factory Database.fromJson(Map<String, dynamic> json) => Database(
        restaurants: List<Restaurant>.from(
          json['restaurants'].map(
            (dynamic x) => Restaurant.fromJson(x as Map<String, dynamic>),
          ) as Iterable<dynamic>,
        ),
      );

  final List<Restaurant> restaurants;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'restaurants': List<dynamic>.from(
          restaurants.map((Restaurant x) => x.toJson()),
        ),
      };
}

class Restaurant {
  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    required this.menus,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json['id'].toString(),
        name: json['name'].toString(),
        description: json['description'].toString(),
        pictureId: json['pictureId'].toString(),
        city: json['city'].toString(),
        rating: double.parse(json['rating'].toString()),
        menus: Menus.fromJson(json['menus'] as Map<String, dynamic>),
      );

  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;
  Menus menus;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'description': description,
        'pictureId': pictureId,
        'city': city,
        'rating': rating,
        'menus': menus.toJson(),
      };
}

class Menus {
  Menus({
    required this.foods,
    required this.drinks,
  });

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
        foods: List<Meal>.from(
          json['foods'].map(
            (dynamic x) => Meal.fromJson(x as Map<String, dynamic>),
          ) as Iterable<dynamic>,
        ),
        drinks: List<Meal>.from(
          json['drinks'].map(
            (dynamic x) => Meal.fromJson(x as Map<String, dynamic>),
          ) as Iterable<dynamic>,
        ),
      );

  List<Meal> drinks;
  List<Meal> foods;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'foods': List<dynamic>.from(foods.map((Meal x) => x.toJson())),
        'drinks': List<dynamic>.from(drinks.map((Meal x) => x.toJson())),
      };
}

class Meal {
  Meal({required this.name});

  factory Meal.fromJson(Map<String, dynamic> json) =>
      Meal(name: json['name'].toString());

  String name;

  Map<String, dynamic> toJson() => <String, String>{'name': name};
}
