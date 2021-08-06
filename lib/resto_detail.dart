import 'package:flutter/material.dart';
import 'database.dart';

class RestoDetail extends StatelessWidget {
  static const String routeName = 'resto-detail';
  const RestoDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Restaurant restaurant =
        ModalRoute.of(context)!.settings.arguments as Restaurant;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            TextButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back),
              label: Text('Go Back'),
            ),
            Image.network(restaurant.pictureId),
            Text(restaurant.name),
            Text(restaurant.city),
            Text(restaurant.rating.toString()),
            Text(restaurant.description),
            ...restaurant.menus.foods.map((e) => Text(e.name)).toList(),
            ...restaurant.menus.drinks.map((e) => Text(e.name)).toList()
          ],
        ),
      ),
    );
  }
}
