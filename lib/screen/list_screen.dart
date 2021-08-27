import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rankedresto/model/resto_list_model.dart';
import 'package:rankedresto/provider/list_provider.dart';
import 'package:rankedresto/util/error_dialog.dart';
import 'package:rankedresto/widget/resto_card.dart';
import 'package:rankedresto/widget/shimmer.dart';
import 'package:rankedresto/widget/top_resto_card.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final ChangeNotifierProvider<ListProvider> _listProvider =
      ChangeNotifierProvider<ListProvider>(
    (ProviderReference ref) => ListProvider(),
  );

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext ctx, ScopedReader watch, _) {
      final ListProvider listState = watch<ListProvider>(_listProvider);

      return RefreshIndicator(
        onRefresh: () async {
          try {
            await listState.fetchRestaurants();
          } catch (_) {
            showError(context, 'Failed to load data');
          }
        },
        child: FutureBuilder<String?>(
          future: listState.fetchRestaurants(),
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
            } else if (listState.restaurants.isNotEmpty) {
              final List<Widget> restaurantsWidget = listState.restaurants
                  .map<Widget>((Restaurant r) => RestoCard(r))
                  .toList();

              final List<Restaurant> sortedRestaurant = listState.restaurants;
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
                itemCount: listState.restaurants.length + 1,
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