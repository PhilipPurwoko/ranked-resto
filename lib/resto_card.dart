import 'package:flutter/material.dart';
import 'database.dart';
import 'resto_detail.dart';

class RestoCard extends StatelessWidget {
  final Restaurant restaurant;
  const RestoCard(this.restaurant, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          RestoDetail.routeName,
          arguments: restaurant,
        );
      },
      child: ListTile(
        leading: Image.network(
          restaurant.pictureId,
          fit: BoxFit.cover,
        ),
        title: Text(restaurant.name),
        subtitle: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 14,
                ),
                Text(restaurant.city),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: 14,
                ),
                Text(restaurant.rating.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
