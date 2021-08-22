import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rankedresto/model/resto_list_model.dart';
import 'package:rankedresto/model/searched_resto.dart';
import 'package:rankedresto/provider/list_provider.dart';
import 'package:rankedresto/util/error_dialog.dart';
import 'package:rankedresto/widget/resto_card.dart';
import 'package:rankedresto/widget/shimmer.dart';
import 'package:rankedresto/widget/top_resto_card.dart';

class RestoList extends StatefulWidget {
  static const String routeName = 'resto-list';
  @override
  _RestoListState createState() => _RestoListState();
}

class _RestoListState extends State<RestoList> {
  bool _searchMode = false;
  bool _fadeTitle = false;
  bool _searching = false;
  List<Restaurant> searchedRestaurant = <Restaurant>[];
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ChangeNotifierProvider<ListProvider> _listProvider =
      ChangeNotifierProvider<ListProvider>(
    (ProviderReference ref) => ListProvider(),
  );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext ctx, ScopedReader watch, _) {
        final ListProvider listState = watch<ListProvider>(_listProvider);

        final Widget searchedRestaurantList = _searching
            ? listTileShimmer
            : searchedRestaurant.isEmpty
                ? const Center(child: Text('No Result Found'))
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: searchedRestaurant.length,
                    itemBuilder: (_, int index) => RestoCard(
                      searchedRestaurant[index],
                    ),
                  );

        final TextField searchBar = TextField(
          autofocus: true,
          controller: _searchController,
          focusNode: _focusNode,
          cursorColor: Colors.white,
          textInputAction: TextInputAction.search,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchMode = false;
                  _fadeTitle = false;
                  _searching = false;
                  searchedRestaurant.clear();
                });
              },
            ),
            labelText: 'Search restaurant',
            fillColor: Colors.white,
            labelStyle: const TextStyle(color: Colors.white),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          onSubmitted: (String keyword) {
            setState(() {
              _searching = true;
            });
            searchRestaurant(keyword).then((List<Restaurant> r) {
              setState(() {
                searchedRestaurant = r;
                _searching = false;
              });
            }).catchError((_) {
              showError(context, 'Failed to search restaurant');
            });
          },
        );

        final AnimatedOpacity appTitle = AnimatedOpacity(
          opacity: _fadeTitle ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          child: AnimatedTextKit(
            isRepeatingAnimation: false,
            displayFullTextOnTap: true,
            animatedTexts: <TypewriterAnimatedText>[
              TypewriterAnimatedText(
                'Ranked Resto',
                speed: const Duration(milliseconds: 100),
              ),
            ],
          ),
        );
        return Scaffold(
          appBar: AppBar(
            title: _searchMode ? searchBar : appTitle,
            actions: <IconButton>[
              if (!_searchMode)
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _fadeTitle = true;
                      _searchMode = true;
                    });
                  },
                ),
            ],
          ),
          body: _searchMode
              ? searchedRestaurantList
              : SafeArea(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      try {
                        await listState.fetchRestaurants();
                      } catch (_) {
                        showError(context, 'Failed to load data');
                      }
                    },
                    child: FutureBuilder<String?>(
                      future: listState.fetchRestaurants(),
                      builder: (_, AsyncSnapshot<String?> snapshot) {
                        if (snapshot.hasError) {
                          return ListView(
                            children: const <Padding>[
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  'Loading Error, please check your network connection. Pull down to refresh',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          );
                        } else if (listState.restaurants.isNotEmpty) {
                          final List<Widget> restaurantsWidget = listState
                              .restaurants
                              .map<Widget>((Restaurant r) => RestoCard(r))
                              .toList();

                          final List<Restaurant> sortedRestaurant =
                              listState.restaurants;
                          sortedRestaurant.sort((Restaurant a, Restaurant b) =>
                              a.rating.compareTo(b.rating));

                          restaurantsWidget.insert(
                            0,
                            TopResto(
                              context,
                              sortedRestaurant.reversed.toList().sublist(0, 5),
                            ),
                          );

                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: listState.restaurants.length + 1,
                            itemBuilder: (_, int i) => restaurantsWidget[i],
                          );
                        } else {
                          return ListView(
                            children: <Widget>[
                              listTileShimmer,
                              listTileShimmer,
                              listTileShimmer,
                              listTileShimmer,
                              listTileShimmer,
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ),
        );
      },
    );
  }
}
