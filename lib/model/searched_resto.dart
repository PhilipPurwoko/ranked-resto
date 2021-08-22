import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rankedresto/model/resto_list_model.dart';

Future<List<Restaurant>> searchRestaurant(String keyword) async {
  try {
    final Uri url =
        Uri.parse('https://restaurant-api.dicoding.dev/search?q=$keyword');
    final http.Response res = await http.get(url);
    final Map<String, dynamic> data =
        json.decode(res.body) as Map<String, dynamic>;
    return SearchedRestaurant.fromJson(data).restaurants;
  } catch (e) {
    throw e.toString();
  }
}

class SearchedRestaurant {
  SearchedRestaurant({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory SearchedRestaurant.fromJson(Map<String, dynamic> json) =>
      SearchedRestaurant(
        error: json['error'].toString() == 'true',
        founded: int.parse(json['founded'].toString()),
        restaurants: List<Restaurant>.from(
          json['restaurants'].map(
            (dynamic x) => Restaurant.fromJson(x as Map<String, dynamic>),
          ) as Iterable<dynamic>,
        ),
      );

  final bool error;
  final int founded;
  final List<Restaurant> restaurants;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'error': error,
        'founded': founded,
        'restaurants': List<dynamic>.from(
          restaurants.map((Restaurant x) => x.toJson()),
        ),
      };
}
