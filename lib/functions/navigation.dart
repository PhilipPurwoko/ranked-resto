import 'package:flutter/cupertino.dart';
import 'package:rankedresto/model/resto_detail_model.dart';
import 'package:rankedresto/model/resto_list_model.dart';
import 'package:rankedresto/screen/detail_screen.dart';

/// Helper class to handle navigation without BuildContext but using GlobalKey / navigatorKey
class NavigationService {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get navigatorKey {
    return _navigatorKey;
  }

  /// Navigate to DetailScreen page and display detailed data by given [restaurant]
  Future<void> navigateToDetailScreen(Restaurant restaurant) async {
    debugPrint(restaurant.pictureId);
    _navigatorKey.currentState!.pushNamed(
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
