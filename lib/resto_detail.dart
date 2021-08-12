import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'database.dart';

class RestoDetail extends StatelessWidget {
  const RestoDetail({Key? key}) : super(key: key);
  static const String routeName = 'resto-detail';

  @override
  Widget build(BuildContext context) {
    final Restaurant restaurant =
        ModalRoute.of(context)!.settings.arguments! as Restaurant;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          restaurant.name,
          style: Theme.of(context).textTheme.headline6,
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
                  image: NetworkImage(restaurant.pictureId),
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
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                enableInfiniteScroll: false,
                height: 120.0,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 15),
              ),
              items: restaurant.menus.foods.map((Meal food) {
                return Builder(
                  builder: (BuildContext ctx) {
                    return Container(
                      width: MediaQuery.of(ctx).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
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
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                enableInfiniteScroll: false,
                height: 120.0,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 15),
              ),
              items: restaurant.menus.drinks.map((Meal drink) {
                return Builder(
                  builder: (BuildContext ctx) {
                    return Container(
                      width: MediaQuery.of(ctx).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
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
