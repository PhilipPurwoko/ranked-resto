import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rankedresto/model/resto_list_model.dart';

class ListProvider with ChangeNotifier {
  List<Restaurant> _restaurant = <Restaurant>[];

  Future<String?> fetchRestaurants() async {
    try {
      final Uri url = Uri.parse('https://restaurant-api.dicoding.dev/list');
      final http.Response res = await http.get(url);
      final Map<String, dynamic> data =
          json.decode(res.body) as Map<String, dynamic>;
      final RestoList restodata = RestoList.fromJson(data);
      if (restodata.error) throw Exception(restodata.message);
      _restaurant = restodata.restaurants;
      notifyListeners();
    } catch (err) {
      if (_restaurant.isEmpty) return Future<String>.error(err);
    }
  }

  List<Restaurant> get restaurants {
    if (_restaurant.isEmpty) return <Restaurant>[];
    return _restaurant;
  }
}
