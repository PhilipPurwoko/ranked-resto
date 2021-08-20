import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:rankedresto/model/resto_detail_model.dart';

import 'carousel_card.dart';

class CarouselDisplay extends StatelessWidget {
  const CarouselDisplay(this.meals, this.image, {Key? key}) : super(key: key);
  final List<CategoryOrMeal> meals;
  final String image;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        enableInfiniteScroll: false,
        enlargeCenterPage: true,
        scrollPhysics: const PageScrollPhysics(),
        aspectRatio: 5 / 2,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 15),
      ),
      items: meals
          .map((CategoryOrMeal meal) => Builder(
                builder: (BuildContext ctx) => CarouselCard(meal.name, image),
              ))
          .toList(),
    );
  }
}
