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
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: Image.network(
                restaurant.pictureId,
                fit: BoxFit.cover,
                loadingBuilder: (
                  BuildContext _,
                  Widget img,
                  ImageChunkEvent? loadingProgress,
                ) {
                  return loadingProgress == null
                      ? img
                      : Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!,
                          ),
                        );
                },
              ),
            ),
          ),
          title: Text(
            restaurant.name,
            style: Theme.of(context).textTheme.headline6,
          ),
          subtitle: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.location_on,
                    size: 14,
                  ),
                  Text(
                    restaurant.city,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.star,
                    size: 14,
                  ),
                  Text(
                    restaurant.rating.toString(),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
