import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rankedresto/model/resto_list_model.dart';
import 'package:rankedresto/model/searched_resto.dart';
import 'package:rankedresto/provider/resto_list_provider.dart';
import 'package:rankedresto/widget/resto_card.dart';
import 'package:rankedresto/widget/shimmer.dart';

class RestoList extends StatefulWidget {
  static const String routeName = 'resto-list';
  @override
  _RestoListState createState() => _RestoListState();
}

class _RestoListState extends State<RestoList> {
  bool _searchMode = false;
  bool _fadeTitle = false;
  bool _searching = false;
  List<Restaurant>? searchedRestaurant;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ChangeNotifierProvider<RestoListProvider> _restoListProvider =
      ChangeNotifierProvider<RestoListProvider>(
    (ProviderReference ref) => RestoListProvider(),
  );

  void showError(BuildContext ctx, String error) {
    showDialog(
      context: ctx,
      builder: (BuildContext bc) => AlertDialog(
        title: const Text('An Error Occured'),
        content: Text(error),
        actions: <TextButton>[
          TextButton(
            onPressed: () {
              Navigator.of(bc).pop();
            },
            child: const Text('Close'),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext ctx, ScopedReader watch, _) {
        final RestoListProvider restoListState =
            watch<RestoListProvider>(_restoListProvider);

        return Scaffold(
          appBar: AppBar(
            leading: _searchMode
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchMode = false;
                        _fadeTitle = false;
                        _searching = false;
                        searchedRestaurant = null;
                      });
                    },
                    icon: const Icon(Icons.arrow_back),
                  )
                : null,
            title: _searchMode
                ? TextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    autofocus: true,
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      labelText: 'Search restaurant',
                      fillColor: Colors.white,
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
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
                      });
                    },
                  )
                : AnimatedOpacity(
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
                  ),
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
              ? _searching
                  ? listShimmer
                  : searchedRestaurant == null
                      ? const Center(child: Text('No Result Found'))
                      : searchedRestaurant!.isEmpty
                          ? const Center(child: Text('No Result Found'))
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: searchedRestaurant!.length,
                              itemBuilder: (_, int index) => RestoCard(
                                searchedRestaurant![index],
                              ),
                            )
              : SafeArea(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      try {
                        await restoListState.loadDatabase();
                      } catch (_) {
                        showError(context, 'Check your network connection');
                      }
                    },
                    child: FutureBuilder<String?>(
                      future: restoListState.loadDatabase(),
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
                        } else if (restoListState.restaurants.isNotEmpty) {
                          return restoListState.restaurants.isEmpty
                              ? const Center(child: Text('Not Found'))
                              : ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: restoListState.restaurants.length,
                                  itemBuilder: (_, int index) => RestoCard(
                                    restoListState.restaurants[index],
                                  ),
                                );
                        } else {
                          return ListView(
                            children: <Widget>[
                              listShimmer,
                              listShimmer,
                              listShimmer,
                              listShimmer,
                              listShimmer,
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
