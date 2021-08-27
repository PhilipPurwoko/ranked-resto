import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomRatingBar extends StatelessWidget {
  const CustomRatingBar(
    this.rating, {
    Key? key,
  }) : super(key: key);

  final double rating;

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      itemPadding: const EdgeInsets.only(right: 5),
      itemSize: 24,
      allowHalfRating: true,
      ignoreGestures: true,
      initialRating: rating,
      onRatingUpdate: (_) {},
      itemBuilder: (_, __) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
    );
  }
}
