import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).primaryColor,
              ),
              style: ButtonStyle(
                alignment: Alignment.centerLeft,
              ),
              label: Text(
                'Go Back',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            AspectRatio(
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
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Text(
                restaurant.name,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                  ),
                  Text(
                    restaurant.city,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 16,
                  ),
                  Text(
                    restaurant.rating.toString(),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                restaurant.description,
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodyText2,
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
                autoPlayInterval: Duration(seconds: 15),
              ),
              items: restaurant.menus.foods.map((Food food) {
                return Builder(
                  builder: (BuildContext ctx) {
                    return Container(
                      width: MediaQuery.of(ctx).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          food.name,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
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
                autoPlayInterval: Duration(seconds: 15),
              ),
              items: restaurant.menus.drinks.map((Drink drink) {
                return Builder(
                  builder: (BuildContext ctx) {
                    return Container(
                      width: MediaQuery.of(ctx).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          drink.name,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
