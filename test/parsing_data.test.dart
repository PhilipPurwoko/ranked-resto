import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:rankedresto/model/resto_detail_model.dart';
import 'package:rankedresto/model/resto_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:rankedresto/model/searched_resto.dart';

void main() {
  group('Parsing JSON from API', () {
    test('Fetch restaurant list data', () async {
      final Uri url = Uri.parse('https://restaurant-api.dicoding.dev/list');
      final http.Response res = await http.get(url);
      final Map<String, dynamic> data =
          json.decode(res.body) as Map<String, dynamic>;
      final RestoList restodata = RestoList.fromJson(data);
      expect(restodata.error, false);
      expect(restodata.restaurants.length, restodata.count);
    });

    test('Fetch single detail restaurant', () async {
      final Uri url = Uri.parse(
          'https://restaurant-api.dicoding.dev/detail/rqdv5juczeskfw1e867');
      final http.Response res = await http.get(url);
      final Map<String, dynamic> data =
          json.decode(res.body) as Map<String, dynamic>;
      final RestoDetail restoDetail = RestoDetail.fromJson(data);
      final RestaurantDetail restaurantDetail = restoDetail.restaurant;
      expect(restoDetail.error, false);
      expect(restaurantDetail.name, 'Melting Pot');
      expect(
        restaurantDetail.pictureId,
        'https://restaurant-api.dicoding.dev/images/small/14',
      );
      expect(restaurantDetail.city, 'Medan');
    });

    test('Search restaurant', () async {
      const String keyword = 'Makan mudah';
      final Uri url =
          Uri.parse('https://restaurant-api.dicoding.dev/search?q=$keyword');
      final http.Response res = await http.get(url);
      final Map<String, dynamic> data =
          json.decode(res.body) as Map<String, dynamic>;
      final SearchedRestaurant searchedRestaurant =
          SearchedRestaurant.fromJson(data);
      expect(searchedRestaurant.error, false);
      expect(
        searchedRestaurant.restaurants
            .map((Restaurant restaurant) => restaurant.name)
            .contains(keyword),
        true,
      );
    });

    test('Send review', () async {
      final Uri url = Uri.parse('https://restaurant-api.dicoding.dev/review');
      final http.Response res = await http.post(
        url,
        headers: <String, String>{
          'X-Auth-Token': '12345',
        },
        body: <String, String>{
          'id': 'rqdv5juczeskfw1e867',
          'name': 'test user',
          'review': 'test review',
        },
      );

      final Map<String, dynamic> data =
          json.decode(res.body) as Map<String, dynamic>;
      final CustomerReviewResponse customerReviewResponse =
          CustomerReviewResponse.fromJson(data);
      expect(customerReviewResponse.error, false);
      expect(customerReviewResponse.customerReviews.isNotEmpty, true);
    });
  });
}
