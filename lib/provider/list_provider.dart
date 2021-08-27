import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rankedresto/model/resto_list_model.dart';

final ChangeNotifierProvider<ListProvider> listProvider =
    ChangeNotifierProvider<ListProvider>(
  (ProviderReference ref) => ListProvider(),
);

class ListProvider with ChangeNotifier {
  List<Restaurant> _restaurants = <Restaurant>[];

  List<Restaurant> get restaurants {
    if (_restaurants.isEmpty) return <Restaurant>[];
    return _restaurants;
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
}
