import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rankedresto/model/resto_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ChangeNotifierProvider<ListProvider> listProvider =
    ChangeNotifierProvider<ListProvider>(
  (ProviderReference ref) => ListProvider(),
);

class ListProvider with ChangeNotifier {
  static const String favoriteRestaurantsKey = 'favorite';
  List<Restaurant> _restaurants = <Restaurant>[];

  List<Restaurant> get restaurants {
    if (_restaurants.isEmpty) return <Restaurant>[];
    return _restaurants;
  }

  Restaurant getRestaurantById(String id) {
    return _restaurants.firstWhere((Restaurant r) => r.id == id);
  }

  Future<String?> fetchRestaurants() async {
    try {
      final Uri url = Uri.parse('https://restaurant-api.dicoding.dev/list');
      final http.Response res = await http.get(url);
      final Map<String, dynamic> data =
          json.decode(res.body) as Map<String, dynamic>;
      final RestoList restodata = RestoList.fromJson(data);
      if (restodata.error) throw Exception(restodata.message);
      _restaurants = restodata.restaurants;
      notifyListeners();
    } catch (e) {
      if (_restaurants.isEmpty) return Future<String>.error(e.toString());
    }
  }

  static Future<List<String>> toogleFavoriesById(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> favorites =
        prefs.getStringList(favoriteRestaurantsKey) ?? <String>[];

    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }

    prefs.setStringList(favoriteRestaurantsKey, favorites);
    return favorites;
  }

  static Future<List<String>> getFavoritesRestaurantsId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(favoriteRestaurantsKey) ?? <String>[];
  }

  static Future<bool> isRestaurantInFavorite(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> favorites =
        prefs.getStringList(favoriteRestaurantsKey) ?? <String>[];
    return favorites.contains(id);
  }
}
