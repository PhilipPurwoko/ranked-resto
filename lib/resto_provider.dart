import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'database.dart';

class RestaurantProvider with ChangeNotifier {
  List<Restaurant>? _restaurant;
  List<Restaurant>? _searchedResto;

  Future<void> loadDatabase() async {
    final String res = await rootBundle.loadString('assets/data.json');
    final data = json.decode(res) as Map<String, dynamic>;
    _restaurant = Database.fromJson(data).restaurants;
    _searchedResto = _restaurant;
    notifyListeners();
  }

  List<Restaurant>? get restaurants {
    return _searchedResto != null ? _searchedResto : null;
  }

  void searchResto(String? name) {
    if (name != null) {
      _searchedResto = _restaurant!
          .where((Restaurant restaurant) =>
              restaurant.name.toLowerCase().contains(name))
          .toList();
      notifyListeners();
    } else {
      _searchedResto = _restaurant;
      notifyListeners();
    }
  }

  void resetResto() {
    _searchedResto = _restaurant;
    notifyListeners();
  }
}
