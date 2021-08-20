import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rankedresto/model/resto_detail_model.dart';

class DetailProvider with ChangeNotifier {
  final Map<String, RestaurantDetail> _restaurants =
      <String, RestaurantDetail>{};

  RestaurantDetail? getResto(String id) {
    return _restaurants[id];
  }

  Future<RestaurantDetail> getRestaurantById(String id) async {
    if (_restaurants[id] == null) {
      final Uri url =
          Uri.parse('https://restaurant-api.dicoding.dev/detail/$id');
      final http.Response res = await http.get(url);
      final Map<String, dynamic> data =
          json.decode(res.body) as Map<String, dynamic>;
      _restaurants[id] = RestoDetail.fromJson(data).restaurant;
      notifyListeners();
    }
    return _restaurants[id]!;
  }

  Future<void> sendReview({
    required String id,
    required String name,
    required String review,
  }) async {
    final Uri url = Uri.parse('https://restaurant-api.dicoding.dev/review');
    final http.Response res = await http.post(
      url,
      headers: <String, String>{
        'X-Auth-Token': '12345',
      },
      body: <String, String>{
        'id': id,
        'name': name,
        'review': review,
      },
    );

    final Map<String, dynamic> data =
        json.decode(res.body) as Map<String, dynamic>;
    _restaurants[id]!.customerReviews =
        CustomerReviewResponse.fromJson(data).customerReviews;
    notifyListeners();
  }
}
