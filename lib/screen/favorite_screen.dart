import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rankedresto/provider/list_provider.dart';
import 'package:rankedresto/widget/resto_card.dart';
import 'package:rankedresto/widget/shimmer.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext ctx, ScopedReader watch, _) {
      final ListProvider listProviderState = watch<ListProvider>(listProvider);

      return RefreshIndicator(
        onRefresh: ListProvider.getFavoritesRestaurantsId,
        child: FutureBuilder<String?>(
            future: listProviderState.fetchRestaurants(),
            builder: (_, __) {
              if (listProviderState.restaurants.isEmpty) {
                return listTileShimmer;
              }
              return FutureBuilder<List<String>>(
                future: ListProvider.getFavoritesRestaurantsId(),
                builder: (_, AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.data == null) {
                    return listTileShimmer;
                  }
                  return snapshot.data!.isEmpty
                      ? const Center(child: Text('No items. Try add something'))
                      : ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, int index) => ListTile(
                            title: RestoCard(
                              listProviderState.getRestaurantById(
                                snapshot.data![index],
                              ),
                            ),
                          ),
                        );
                },
              );
            }),
      );
    });
  }
}
