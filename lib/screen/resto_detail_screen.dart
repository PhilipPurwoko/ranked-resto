import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:rankedresto/model/resto_detail_model.dart';

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
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: Hero(
                tag: restaurant.id,
                child: FadeInImage(
                  placeholder: const AssetImage('assets/placeholder.png'),
                  image: NetworkImage(
                    'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.location_on, size: 16),
                  Text(restaurant.city),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.star, size: 16),
                  Text(restaurant.rating.toString()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                restaurant.description,
                textAlign: TextAlign.justify,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Foods',
                style: headline6,
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                enableInfiniteScroll: false,
                height: 120.0,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 15),
              ),
              items: restaurant.menus.foods.map((CategoryOrMeal food) {
                return Builder(
                  builder: (BuildContext ctx) {
                    return Container(
                      width: MediaQuery.of(ctx).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(child: Text(food.name)),
                    );
                  },
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Drinks',
                style: headline6,
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                enableInfiniteScroll: false,
                height: 120.0,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 15),
              ),
              items: restaurant.menus.drinks.map((CategoryOrMeal drink) {
                return Builder(
                  builder: (BuildContext ctx) {
                    return Container(
                      width: MediaQuery.of(ctx).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(child: Text(drink.name)),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
