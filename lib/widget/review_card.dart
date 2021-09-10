import 'package:flutter/material.dart';
import 'package:rankedresto/model/customer_review.dart';

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
          Text(
            review.date,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      subtitle: Text(review.review),
    );
  }
}
