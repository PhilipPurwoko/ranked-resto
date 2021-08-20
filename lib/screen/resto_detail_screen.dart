import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rankedresto/model/resto_detail_model.dart';
import 'package:rankedresto/widget/carousel_display.dart';
import 'package:rankedresto/widget/review_card.dart';
import 'package:rankedresto/widget/shimmer.dart';

class RestoDetailScreen extends StatelessWidget {
  const RestoDetailScreen({Key? key}) : super(key: key);
  static const String routeName = 'resto-detail';

  @override
  Widget build(BuildContext context) {
    final RestaurantDetail restaurant =
        ModalRoute.of(context)!.settings.arguments! as RestaurantDetail;
    final TextStyle? headline6 = Theme.of(context).textTheme.headline6;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          restaurant.name,
          style: headline6!.copyWith(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<RestaurantDetail>(
            future: getRestaurantByID(restaurant.id),
            builder: (
              BuildContext _,
              AsyncSnapshot<RestaurantDetail> snapshot,
            ) {
              if (snapshot.hasData) {
                return ListView(
                  physics: const BouncingScrollPhysics(),
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 16.0 / 9.0,
                      child: Hero(
                        tag: restaurant.id,
                        child: FadeInImage(
                          placeholder:
                              const AssetImage('assets/placeholder.png'),
                          image: NetworkImage(
                            'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.location_on, size: 16),
                          Text(
                            '${snapshot.data!.address}, ${snapshot.data!.city}',
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          RatingBar.builder(
                            itemSize: 24,
                            allowHalfRating: true,
                            ignoreGestures: true,
                            initialRating: snapshot.data!.rating,
                            onRatingUpdate: (_) {},
                            itemBuilder: (_, __) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ),
                          Text(
                            '(${snapshot.data!.rating.toString()}) (${snapshot.data!.customerReviews!.length.toString()})',
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: snapshot.data!.categories!
                            .map<Padding>((CategoryOrMeal e) => Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Chip(label: Text(e.name)),
                                ))
                            .toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        snapshot.data!.description,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        'Foods',
                        style: headline6,
                      ),
                    ),
                    CarouselDisplay(
                      snapshot.data!.menus!.foods,
                      'assets/food.jpg',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        'Drinks',
                        style: headline6,
                      ),
                    ),
                    CarouselDisplay(
                      snapshot.data!.menus!.drinks,
                      'assets/drink.jpg',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        'Reviews',
                        style: headline6,
                      ),
                    ),
                    ...snapshot.data!.customerReviews!
                        .map<ReviewCard>((CustomerReview e) => ReviewCard(e))
                        .toList(),
                    const SizedBox(height: 20),
                  ],
                );
              } else {
                return ListView(
                  children: <Widget>[
                    imageShimmer,
                    textShimmer,
                    textShimmer,
                    imageShimmer,
                    textShimmer,
                    listShimmer,
                    listShimmer,
                  ],
                );
              }
            }),
      ),
    );
  }
}
