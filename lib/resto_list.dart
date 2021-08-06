import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'resto_provider.dart';
import 'resto_card.dart';

class RestoList extends StatefulWidget {
  static const String routeName = 'resto-list';
  @override
  _RestoListState createState() => _RestoListState();
}

class _RestoListState extends State<RestoList> {
  bool _seachMode = false;
  TextEditingController _searchController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Provider.of<RestaurantProvider>(context, listen: false).loadDatabase();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RestaurantProvider restaurantProvider =
        Provider.of<RestaurantProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              color: Theme.of(context).primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Ranked Resto',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _seachMode
                            ? TextField(
                                controller: _searchController,
                                focusNode: focusNode,
                                autofocus: true,
                                decoration: const InputDecoration(
                                  labelText: 'Search restaurant',
                                ),
                                onChanged: (String name) =>
                                    restaurantProvider.searchResto(name),
                                onSubmitted: (String name) =>
                                    restaurantProvider.searchResto(name),
                              )
                            : Text('Recomended restaurants for you!'),
                      ),
                      IconButton(
                        onPressed: () {
                          if (_seachMode) {
                            _searchController.clear();
                            restaurantProvider.resetResto();
                          }

                          setState(() {
                            _seachMode = !_seachMode;
                          });
                        },
                        icon: Icon(_seachMode ? Icons.cancel : Icons.search),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: restaurantProvider.restaurants == null
                  ? Center(child: CircularProgressIndicator())
                  : restaurantProvider.restaurants!.length <= 0
                      ? Center(child: Text('Not Found'))
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: restaurantProvider.restaurants!.length,
                          itemBuilder: (_, int index) => RestoCard(
                            restaurantProvider.restaurants![index],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
