import 'package:flutter/cupertino.dart';
import 'package:rankedresto/model/resto_detail_model.dart';
import 'package:rankedresto/model/resto_list_model.dart';
import 'package:rankedresto/screen/detail_screen.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> navigateToDetailScreen(Restaurant restaurant) async {
    debugPrint(restaurant.pictureId);
    navigatorKey.currentState!.pushNamed(
      DetailScreen.routeName,
      arguments: RestaurantDetail(
        id: restaurant.id,
        name: restaurant.name,
        description: restaurant.description,
        city: restaurant.city,
        pictureId: restaurant.pictureId,
        rating: restaurant.rating,
      ),
    );
  }
}
