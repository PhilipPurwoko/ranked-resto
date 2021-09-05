class RestoList {
  RestoList({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory RestoList.fromJson(Map<String, dynamic> json) => RestoList(
        error: json['error'].toString() == 'true',
        message: json['message'].toString(),
        count: int.parse(json['count'].toString()),
        restaurants: List<Restaurant>.from(
          json['restaurants'].map(
            (dynamic x) => Restaurant.fromJson(x as Map<String, dynamic>),
          ) as Iterable<dynamic>,
        ),
      );

  final bool error;
  final String message;
  final int count;
  final List<Restaurant> restaurants;

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
        pictureId:
            'https://restaurant-api.dicoding.dev/images/small/${json['pictureId']}',
        city: json['city'].toString(),
        rating: double.parse(json['rating'].toString()),
      );

  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;

  Map<String, String> toJson() => <String, String>{
        'id': id,
        'name': name,
        'description': description,
        'pictureId': pictureId.split('/').last,
        'city': city,
        'rating': rating.toString(),
      };
}
