import 'package:flutter/material.dart';
import 'package:rankedresto/model/resto_detail_model.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard(this.review, {Key? key}) : super(key: key);

  final CustomerReview review;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(backgroundColor: Colors.grey),
      title: Row(
        children: <Widget>[
          Text(review.name),
          const Spacer(),
          Text(review.date),
        ],
      ),
      subtitle: Text(review.review),
    );
  }
}
