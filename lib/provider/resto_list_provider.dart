import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rankedresto/model/resto_list_model.dart';

class RestoListProvider with ChangeNotifier {
  List<Restaurant>? _restaurant;

  Future<void> loadDatabase() async {
    final String res = await rootBundle.loadString('assets/data.json');
    final Map<String, dynamic> data = json.decode(res) as Map<String, dynamic>;
    _restaurant = RestoList.fromJson(data).restaurants;
    notifyListeners();
  }

  List<Restaurant>? get restaurants {
    return _restaurant;
  }

  // void searchResto(String? name) {
  //   if (name != null) {
  //     _searchedResto = _restaurant!
  //         .where((Restaurant restaurant) =>
  //             restaurant.name.toLowerCase().contains(name))
  //         .toList();
  //     notifyListeners();
  //   } else {
  //     _searchedResto = _restaurant;
  //     notifyListeners();
  //   }
  // }
}
