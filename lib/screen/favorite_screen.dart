import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rankedresto/provider/detail_provider.dart';
import 'package:rankedresto/widget/resto_card.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext ctx, ScopedReader watch, _) {
      final DetailProvider detailState = watch<DetailProvider>(detailProvider);

      return detailState.filterByFavorites.isNotEmpty
          ? ListView.builder(
              itemCount: detailState.filterByFavorites.length,
              itemBuilder: (_, int index) => RestoCard(
                detailState.filterByFavorites[index].toRestaurant(),
              ),
            )
          : const Center(child: Text('No items. Try add something'));
    });
  }
}
