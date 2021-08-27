class CustomerReviewResponse {
  CustomerReviewResponse({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory CustomerReviewResponse.fromJson(Map<String, dynamic> json) =>
      CustomerReviewResponse(
        error: json['error'].toString() == 'true',
        message: json['message'].toString(),
        customerReviews: List<CustomerReview>.from(
          json['customerReviews'].map(
            (dynamic x) => CustomerReview.fromJson(x as Map<String, dynamic>),
          ) as Iterable<dynamic>,
        ),
      );

  final bool error;
  final String message;
  final List<CustomerReview> customerReviews;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'error': error,
        'message': message,
        'customerReviews': List<dynamic>.from(
            customerReviews.map((CustomerReview x) => x.toJson())),
      };
}

class RestoDetail {
  RestoDetail({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory RestoDetail.fromJson(Map<String, dynamic> json) => RestoDetail(
        error: json['error'] as bool,
        message: json['message'].toString(),
        restaurant: RestaurantDetail.fromJson(
            json['restaurant'] as Map<String, dynamic>),
      );

  final bool error;
  final String message;
  final RestaurantDetail restaurant;

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
    required this.rating,
    required this.pictureId,
    this.address,
    this.categories,
    this.menus,
    this.customerReviews,
    this.isFavorite = false,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) =>
      RestaurantDetail(
        id: json['id'].toString(),
        name: json['name'].toString(),
        description: json['description'].toString(),
        city: json['city'].toString(),
        address: json['address'].toString(),
        pictureId:
            'https://restaurant-api.dicoding.dev/images/medium/${json['pictureId']}',
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

  bool isFavorite;
  final String id;
  final String name;
  final String description;
  final String city;
  final String pictureId;
  final double rating;
  final String? address;
  final Menus? menus;
  final List<CategoryOrMeal>? categories;
  List<CustomerReview>? customerReviews;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'description': description,
        'city': city,
        'address': address,
        'pictureId': pictureId,
        'categories': categories != null
            ? List<dynamic>.from(
                categories!.map((CategoryOrMeal x) => x.toJson()))
            : const Iterable<dynamic>.empty(),
        'menus': menus?.toJson() ?? '',
        'rating': rating,
        'customerReviews': customerReviews != null
            ? List<dynamic>.from(
                customerReviews!.map((CustomerReview x) => x.toJson()))
            : const Iterable<dynamic>.empty(),
      };
}

class CategoryOrMeal {
  CategoryOrMeal({
    required this.name,
  });

  factory CategoryOrMeal.fromJson(Map<String, dynamic> json) =>
      CategoryOrMeal(name: json['name'].toString());

  final String name;

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

  final String name;
  final String review;
  final String date;

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

  final List<CategoryOrMeal> foods;
  final List<CategoryOrMeal> drinks;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'foods':
            List<dynamic>.from(foods.map((CategoryOrMeal x) => x.toJson())),
        'drinks':
            List<dynamic>.from(drinks.map((CategoryOrMeal x) => x.toJson())),
      };
}
