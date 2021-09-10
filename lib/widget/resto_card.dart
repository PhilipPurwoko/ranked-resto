import 'package:flutter/material.dart';
import 'package:rankedresto/model/resto_detail_model.dart';
import 'package:rankedresto/model/resto_list_model.dart';
import 'package:rankedresto/screen/detail_screen.dart';

class RestoCard extends StatelessWidget {
  const RestoCard(this.restaurant, {Key? key}) : super(key: key);
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
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
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListTile(
          leading: AspectRatio(
            aspectRatio: 16 / 9,
            child: FadeInImage(
              fit: BoxFit.cover,
              placeholder: const AssetImage('assets/placeholder.png'),
              imageErrorBuilder: (
                BuildContext _,
                Object error,
                StackTrace? stackTrace,
              ) =>
                  Image.asset(
                'assets/placeholder.png',
                fit: BoxFit.fitWidth,
              ),
              image: NetworkImage(
                restaurant.pictureId,
              ),
            ),
          ),
          title: Text(restaurant.name),
          subtitle: Row(
            children: <Widget>[
              const Icon(
                Icons.location_on,
                color: Colors.grey,
                size: 16,
              ),
              Text(restaurant.city),
            ],
          ),
          trailing: SizedBox(
            width: 45,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.star,
                  color: Colors.yellow[600],
                ),
                Text(restaurant.rating.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
