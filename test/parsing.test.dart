import 'package:flutter_test/flutter_test.dart';
import 'package:rankedresto/model/customer_review.dart';
import 'package:rankedresto/model/resto_detail_model.dart';
import 'package:rankedresto/model/resto_list_model.dart';
import 'package:rankedresto/model/searched_resto.dart';
import 'data.mock.dart';

void main() {
  test('Parsing Restaurant List', () {
    final RestoList restoList = RestoList.fromJson(getJsonOf(DataString.list));
    expect(restoList.error, false);
    expect(restoList.message, 'success');
    expect(restoList.count, 20);
    expect(restoList.restaurants, hasLength(2));
    expect(
      restoList.restaurants.map((Restaurant r) => r.id),
      contains('rqdv5juczeskfw1e867'),
    );
  });

  test('Parsing Detail Restaurant', () {
    final RestoDetail restoDetail =
        RestoDetail.fromJson(getJsonOf(DataString.detail));
    expect(restoDetail.error, false);
    expect(restoDetail.message, 'success');
    expect(restoDetail.restaurant.id, 'rqdv5juczeskfw1e867');
    expect(restoDetail.restaurant.name, 'Melting Pot');
  });

  test('Parsing Searching Restaurant', () {
    final SearchedRestaurant searchedRestaurant =
        SearchedRestaurant.fromJson(getJsonOf(DataString.search));
    expect(searchedRestaurant.error, false);
    expect(searchedRestaurant.founded, 1);
    expect(searchedRestaurant.restaurants, hasLength(1));
    expect(searchedRestaurant.restaurants.first.id, 'fnfn8mytkpmkfw1e867');
  });

  test('Parsing Sending Review Response', () {
    final CustomerReviewResponse customerReviewResponse =
        CustomerReviewResponse.fromJson(getJsonOf(DataString.addReview));
    expect(customerReviewResponse.error, false);
    expect(customerReviewResponse.message, 'success');
    expect(customerReviewResponse.customerReviews.isNotEmpty, true);
    expect(customerReviewResponse.customerReviews, hasLength(2));
    expect(
      customerReviewResponse.customerReviews.map((CustomerReview r) => r.name),
      contains('Ahmad'),
    );
  });
}
