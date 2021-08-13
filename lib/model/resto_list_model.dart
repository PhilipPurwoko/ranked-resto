class RestoList {
  RestoList({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory RestoList.fromJson(Map<String, dynamic> json) => RestoList(
        error: json['error'] as bool,
        message: json['message'].toString(),
        count: int.parse(json['count'].toString()),
        restaurants: List<Restaurant>.from(
          json['restaurants'].map(
            (dynamic x) => Restaurant.fromJson(x as Map<String, dynamic>),
          ) as Iterable<dynamic>,
        ),
      );

  bool error;
  String message;
  int count;
  List<Restaurant> restaurants;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'error': error,
        'message': message,
        'count': count,
        'restaurants':
            List<dynamic>.from(restaurants.map((Restaurant x) => x.toJson())),
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
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json['id'].toString(),
        name: json['name'].toString(),
        description: json['description'].toString(),
        pictureId: json['pictureId'].toString(),
        city: json['city'].toString(),
        rating: double.parse(json['rating'].toString()),
      );

  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'description': description,
        'pictureId': pictureId,
        'city': city,
        'rating': rating,
      };
}
