import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:rankedresto/model/resto_list_model.dart';
import 'package:rankedresto/model/searched_resto.dart';
import 'package:rankedresto/screen/favorite_screen.dart';
import 'package:rankedresto/screen/list_screen.dart';
import 'package:rankedresto/screen/setting_screen.dart';
import 'package:rankedresto/util/error_dialog.dart';
import 'package:rankedresto/widget/resto_card.dart';
import 'package:rankedresto/widget/shimmer.dart';

class NavScreen extends StatefulWidget {
  static const String routeName = 'home';
  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _navigationIndex = 0;
  bool _searchMode = false;
  bool _fadeTitle = false;
  bool _searching = false;

  final FocusNode _focusNode = FocusNode();
  List<Restaurant> searchedRestaurant = <Restaurant>[];
  final TextEditingController _searchController = TextEditingController();

  final List<Widget> _screens = <Widget>[
    const ListScreen(),
    const FavoriteScreen(),
    const SettingScreen(),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          tooltip: 'Cancel',
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
              tooltip: 'Search Restaurant',
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
          : IndexedStack(index: _navigationIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navigationIndex,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          setState(() {
            _navigationIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Explore',
            icon: Icon(Icons.restaurant),
          ),
          BottomNavigationBarItem(
            label: 'Favorite',
            icon: Icon(Icons.favorite),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
