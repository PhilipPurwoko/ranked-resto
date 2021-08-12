import 'package:flutter/material.dart';
import 'database.dart';
import 'resto_detail.dart';

class RestoCard extends StatelessWidget {
  const RestoCard(this.restaurant, {Key? key}) : super(key: key);
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          RestoDetail.routeName,
          arguments: restaurant,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListTile(
          leading: AspectRatio(
            aspectRatio: 16 / 9,
            child: Hero(
              tag: restaurant.id,
              child: FadeInImage(
                placeholder: const AssetImage('assets/placeholder.png'),
                image: NetworkImage(restaurant.pictureId),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(restaurant.name),
          subtitle: Text(restaurant.city),
          trailing: SizedBox(
            width: 45,
            child: Row(
              children: <Widget>[
                Icon(Icons.star, color: Colors.yellow[600]),
                Text(restaurant.rating.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
