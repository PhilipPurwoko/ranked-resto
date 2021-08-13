class RestoDetail {
  RestoDetail({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory RestoDetail.fromJson(Map<String, dynamic> json) => RestoDetail(
        error: json['error'] as bool,
        message: json['message'].toString(),
        restaurant:
            RestaurantDetail.fromJson(json['Detail'] as Map<String, dynamic>),
      );

  bool error;
  String message;
  RestaurantDetail restaurant;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'error': error,
        'message': message,
        'restaurant': restaurant.toJson(),
      };
}

class RestaurantDetail {
  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.categories,
    required this.menus,
    required this.rating,
    required this.customerReviews,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) =>
      RestaurantDetail(
        id: json['id'].toString(),
        name: json['name'].toString(),
        description: json['description'].toString(),
        city: json['city'].toString(),
        address: json['address'].toString(),
        pictureId: json['pictureId'].toString(),
        rating: double.parse(json['rating'].toString()),
        menus: Menus.fromJson(json['menus'] as Map<String, dynamic>),
        categories: List<CategoryOrMeal>.from(
          json['categories'].map(
            (dynamic x) => CategoryOrMeal.fromJson(x as Map<String, dynamic>),
          ) as Iterable<dynamic>,
        ),
        customerReviews: List<CustomerReview>.from(
          json['customerReviews'].map(
            (dynamic x) => CustomerReview.fromJson(x as Map<String, dynamic>),
          ) as Iterable<dynamic>,
        ),
      );

  String id;
  String name;
  String description;
  String city;
  String address;
  String pictureId;
  List<CategoryOrMeal> categories;
  Menus menus;
  double rating;
  List<CustomerReview> customerReviews;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'description': description,
        'city': city,
        'address': address,
        'pictureId': pictureId,
        'categories': List<dynamic>.from(
            categories.map((CategoryOrMeal x) => x.toJson())),
        'menus': menus.toJson(),
        'rating': rating,
        'customerReviews': List<dynamic>.from(
            customerReviews.map((CustomerReview x) => x.toJson())),
      };
}

class CategoryOrMeal {
  CategoryOrMeal({
    required this.name,
  });

  factory CategoryOrMeal.fromJson(Map<String, dynamic> json) =>
      CategoryOrMeal(name: json['name'].toString());

  String name;

  Map<String, dynamic> toJson() => <String, String>{'name': name};
}

class CustomerReview {
  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
        name: json['name'].toString(),
        review: json['review'].toString(),
        date: json['date'].toString(),
      );

  String name;
  String review;
  String date;

  Map<String, dynamic> toJson() => <String, String>{
        'name': name,
        'review': review,
        'date': date,
      };
}

class Menus {
  Menus({
    required this.foods,
    required this.drinks,
  });

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
        foods: List<CategoryOrMeal>.from(
          json['foods'].map(
            (dynamic x) => CategoryOrMeal.fromJson(x as Map<String, dynamic>),
          ) as Iterable<dynamic>,
        ),
        drinks: List<CategoryOrMeal>.from(
          json['drinks'].map(
            (dynamic x) => CategoryOrMeal.fromJson(x as Map<String, dynamic>),
          ) as Iterable<dynamic>,
        ),
      );

  List<CategoryOrMeal> foods;
  List<CategoryOrMeal> drinks;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'foods':
            List<dynamic>.from(foods.map((CategoryOrMeal x) => x.toJson())),
        'drinks':
            List<dynamic>.from(drinks.map((CategoryOrMeal x) => x.toJson())),
      };
}
