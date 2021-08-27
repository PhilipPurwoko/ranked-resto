import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:rankedresto/model/resto_detail_model.dart';
import 'package:rankedresto/model/resto_list_model.dart';
import 'package:rankedresto/screen/detail_screen.dart';
import 'package:rankedresto/widget/carousel_card.dart';
import 'package:rankedresto/widget/rating_bar.dart';

class TopResto extends StatelessWidget {
  const TopResto(this.ctx, this.bestRestaurants, {Key? key}) : super(key: key);
  final BuildContext ctx;
  final List<Restaurant> bestRestaurants;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 5 / 2,
          autoPlay: true,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          autoPlayInterval: const Duration(seconds: 15),
          scrollPhysics: const BouncingScrollPhysics(),
        ),
        items: bestRestaurants
            .map((Restaurant restaurant) => GestureDetector(
                  onTap: () {
                    Navigator.of(ctx).pushNamed(
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
                  child: CarouselCard(
                    restaurant.name,
                    restaurant.pictureId,
                    useNetwork: true,
                    subtitle: Text(restaurant.city),
                    trailing: CustomRatingBar(restaurant.rating),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
