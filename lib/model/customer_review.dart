class CustomerReviewResponse {
  CustomerReviewResponse({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory CustomerReviewResponse.fromJson(Map<String, dynamic> json) =>
      CustomerReviewResponse(
        error: json['error'].toString() == 'true',
        message: json['message'].toString(),
        customerReviews: List<CustomerReview>.from(
          json['customerReviews'].map(
            (dynamic x) => CustomerReview.fromJson(x as Map<String, dynamic>),
          ) as Iterable<dynamic>,
        ),
      );

  final bool error;
  final String message;
  final List<CustomerReview> customerReviews;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'error': error,
        'message': message,
        'customerReviews': List<dynamic>.from(
            customerReviews.map((CustomerReview x) => x.toJson())),
      };
}

class CustomerReview {
  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
        name: json['name'].toString(),
        review: json['review'].toString(),
        date: json['date'].toString(),
      );

  final String name;
  final String review;
  final String date;

  Map<String, dynamic> toJson() => <String, String>{
        'name': name,
        'review': review,
        'date': date,
      };
}
