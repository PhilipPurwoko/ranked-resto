import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rankedresto/model/customer_review.dart';
import 'package:rankedresto/model/resto_detail_model.dart';

final ChangeNotifierProvider<DetailProvider> detailProvider =
    ChangeNotifierProvider<DetailProvider>(
  (ProviderReference ref) => DetailProvider(),
);

class DetailProvider with ChangeNotifier {
  final Map<String, RestaurantDetail> _restaurants =
      <String, RestaurantDetail>{};

  List<RestaurantDetail> get restaurants {
    if (_restaurants.isEmpty) return <RestaurantDetail>[];
    return _restaurants.values.toList();
  }

  RestaurantDetail? getFetchedRestaurantById(String id) {
    return _restaurants[id];
  }

  Future<RestaurantDetail>? fetchRestaurantById(String id) async {
    try {
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
    } catch (e) {
      return Future<RestaurantDetail>.error(e.toString());
    }
  }

  Future<List<CustomerReview>> sendReview({
    required String id,
    required String name,
    required String review,
  }) async {
    try {
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

      final List<CustomerReview> customerReviewsResponse =
          CustomerReviewResponse.fromJson(data).customerReviews;

      _restaurants[id]!.customerReviews = customerReviewsResponse;
      notifyListeners();
      return customerReviewsResponse;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
