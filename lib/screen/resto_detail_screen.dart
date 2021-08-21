import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rankedresto/model/resto_detail_model.dart';
import 'package:rankedresto/provider/detail_provider.dart';
import 'package:rankedresto/util/error_dialog.dart';
import 'package:rankedresto/widget/carousel_display.dart';
import 'package:rankedresto/widget/review_card.dart';
import 'package:rankedresto/widget/shimmer.dart';

class RestoDetailScreen extends StatefulWidget {
  const RestoDetailScreen({Key? key}) : super(key: key);
  static const String routeName = 'resto-detail';

  @override
  _RestoDetailScreenState createState() => _RestoDetailScreenState();
}

class _RestoDetailScreenState extends State<RestoDetailScreen> {
  bool sendingReview = false;
  final TextEditingController reviewController = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final ChangeNotifierProvider<DetailProvider> _detailProvider =
      ChangeNotifierProvider<DetailProvider>(
    (ProviderReference ref) => DetailProvider(),
  );

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  Future<void> addReview({
    required BuildContext context,
    required DetailProvider detailState,
    required String id,
    required String text,
  }) async {
    final bool isValid = _form.currentState!.validate();
    if (!isValid) return;
    setState(() {
      sendingReview = true;
    });

    try {
      await detailState.sendReview(
        id: id,
        name: 'Test User',
        review: text,
      );
      setState(() {
        reviewController.clear();
        sendingReview = false;
      });
    } catch (e) {
      showError(
        context,
        'Failed to send review',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final RestaurantDetail passedRestaurantData =
        ModalRoute.of(context)!.settings.arguments! as RestaurantDetail;
    final TextStyle? headline6 = Theme.of(context).textTheme.headline6;

    return Consumer(builder: (BuildContext ctx, ScopedReader watch, _) {
      final DetailProvider detailState = watch<DetailProvider>(_detailProvider);
      return Scaffold(
        appBar: AppBar(
          title: Text(
            passedRestaurantData.name,
            style: headline6!.copyWith(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: FutureBuilder<RestaurantDetail>(
              future: detailState.getRestaurantById(passedRestaurantData.id),
              builder: (_, AsyncSnapshot<RestaurantDetail> snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    physics: const BouncingScrollPhysics(),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: AspectRatio(
                          aspectRatio: 16.0 / 9.0,
                          child: Hero(
                            tag: passedRestaurantData.id,
                            child: FadeInImage(
                              fit: BoxFit.cover,
                              placeholder: const AssetImage(
                                'assets/placeholder.png',
                              ),
                              image: NetworkImage(
                                'https://restaurant-api.dicoding.dev/images/medium/${passedRestaurantData.pictureId}',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
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
                              .map<Chip>((CategoryOrMeal category) => Chip(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    label: Text(category.name),
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
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Text('Foods', style: headline6),
                      ),
                      CarouselDisplay(
                        snapshot.data!.menus!.foods,
                        'assets/food.jpg',
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Text('Drinks', style: headline6),
                      ),
                      CarouselDisplay(
                        snapshot.data!.menus!.drinks,
                        'assets/drink.jpg',
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Text('Reviews', style: headline6),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                          key: _form,
                          child: TextFormField(
                            enabled: !sendingReview,
                            controller: reviewController,
                            textInputAction: TextInputAction.send,
                            validator: (String? text) {
                              if (text == null || text.isEmpty) {
                                return 'Review cannot be empty';
                              } else {
                                if (text.split(' ').length < 3) {
                                  return 'Review should contain at least 3 words';
                                }
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Publish Your Review',
                              suffixIcon: sendingReview
                                  ? const CircularProgressIndicator()
                                  : IconButton(
                                      icon: const Icon(Icons.send),
                                      onPressed: () {
                                        addReview(
                                          context: context,
                                          detailState: detailState,
                                          id: passedRestaurantData.id,
                                          text: reviewController.text,
                                        );
                                      },
                                    ),
                            ),
                            onFieldSubmitted: (_) {
                              addReview(
                                context: context,
                                detailState: detailState,
                                id: passedRestaurantData.id,
                                text: reviewController.text,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...snapshot.data!.customerReviews!
                          .map<ReviewCard>((CustomerReview r) => ReviewCard(r))
                          .toList(),
                      const SizedBox(height: 20),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Failed to load data. Please check your network connection',
                    ),
                  );
                } else {
                  return ListView(
                    children: <Widget>[
                      imageShimmer,
                      textShimmer,
                      textShimmer,
                      imageShimmer,
                      textShimmer,
                      listTileShimmer,
                      listTileShimmer,
                    ],
                  );
                }
              }),
        ),
      );
    });
  }
}
