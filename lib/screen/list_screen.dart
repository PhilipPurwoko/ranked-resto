import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rankedresto/functions/error_dialog.dart';
import 'package:rankedresto/model/resto_list_model.dart';
import 'package:rankedresto/provider/list_provider.dart';
import 'package:rankedresto/widget/resto_card.dart';
import 'package:rankedresto/widget/shimmer.dart';
import 'package:rankedresto/widget/top_resto_card.dart';

class ListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext ctx, ScopedReader watch, _) {
      final ListProvider listProviderState = watch<ListProvider>(listProvider);

      return RefreshIndicator(
        onRefresh: () async {
          try {
            await listProviderState.fetchRestaurants();
          } catch (_) {
            showError(context, 'Failed to load data');
          }
        },
        child: FutureBuilder<String?>(
          future: listProviderState.fetchRestaurants(),
          builder: (_, AsyncSnapshot<String?> snapshot) {
            if (snapshot.hasError) {
              return ListView(
                children: const <Padding>[
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Loading Error, please check your network connection. Pull down to refresh',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            } else if (listProviderState.restaurants.isNotEmpty) {
              final List<Widget> restaurantsWidget = listProviderState
                  .restaurants
                  .map<Widget>((Restaurant r) => RestoCard(r))
                  .toList();

              final List<Restaurant> sortedRestaurant =
                  listProviderState.restaurants;

              sortedRestaurant.sort(
                  (Restaurant a, Restaurant b) => a.rating.compareTo(b.rating));

              restaurantsWidget.insert(
                0,
                TopResto(
                  context,
                  sortedRestaurant.reversed.toList().sublist(0, 5),
                ),
              );

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: listProviderState.restaurants.length + 1,
                itemBuilder: (_, int i) => restaurantsWidget[i],
              );
            } else {
              return ListView(
                children: <Widget>[
                  listTileShimmer,
                  listTileShimmer,
                  listTileShimmer,
                  listTileShimmer,
                  listTileShimmer,
                ],
              );
            }
          },
        ),
      );
    });
  }
}
