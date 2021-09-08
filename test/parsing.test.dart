import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:rankedresto/model/resto_detail_model.dart';
import 'package:rankedresto/model/resto_list_model.dart';
import 'package:rankedresto/model/searched_resto.dart';
import 'package:rankedresto/provider/detail_provider.dart';
import 'package:rankedresto/provider/list_provider.dart';

void main() {
  group('Parsing JSON from API', () {
    test('Fetch restaurant list data', () async {
      final ListProvider listProvider = ListProvider();
      await listProvider.fetchRestaurants();
      expect(listProvider.restaurants.isNotEmpty, true);
    });

    test('Fetch single detail restaurant', () async {
      const String id = 'rqdv5juczeskfw1e867';
      final DetailProvider detailProvider = DetailProvider();
      await detailProvider.fetchRestaurantById(id);
      final RestaurantDetail? restaurantDetail =
          detailProvider.getFetchedRestaurantById(id);
      expect(restaurantDetail != null, true);
      expect(restaurantDetail!.id, id);
      expect(restaurantDetail.name, 'Melting Pot');
      expect(restaurantDetail.city, 'Medan');
    });

    test('Search restaurant', () async {
      const String keyword = 'Makan mudah';
      final List<Restaurant> restaurants = await searchRestaurant(keyword);
      expect(restaurants.isNotEmpty, true);
      expect(restaurants.map((Restaurant r) => r.name).contains(keyword), true);
    });

    test('Send review', () async {
      const String id = 'rqdv5juczeskfw1e867';
      final String randomUniqueName =
          'test user ${Random().nextInt(1000)} ${DateTime.now().millisecond}';
      final DetailProvider detailProvider = DetailProvider();
      await detailProvider.fetchRestaurantById(id);
      final List<CustomerReview> customerReviews =
          await detailProvider.sendReview(
        id: id,
        name: randomUniqueName,
        review: 'test review',
      );

      expect(customerReviews.isNotEmpty, true);
      expect(
        customerReviews
            .map((CustomerReview review) => review.name)
            .contains(randomUniqueName),
        true,
      );
    });
  });
}
