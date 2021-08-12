import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'resto_card.dart';
import 'resto_provider.dart';

class RestoList extends StatefulWidget {
  static const String routeName = 'resto-list';
  @override
  _RestoListState createState() => _RestoListState();
}

class _RestoListState extends State<RestoList> {
  bool _seachMode = false;
  final TextEditingController _searchController = TextEditingController();
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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
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
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontSize: 24),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _seachMode
                              ? TextField(
                                  controller: _searchController,
                                  focusNode: focusNode,
                                  autofocus: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Search restaurant',
                                    fillColor: Color(0xFF98ee99),
                                    labelStyle: TextStyle(
                                      color: Color(0xFF98ee99),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF98ee99),
                                      ),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF98ee99),
                                      ),
                                    ),
                                  ),
                                  onChanged: (String name) =>
                                      restaurantProvider.searchResto(name),
                                  onSubmitted: (String name) =>
                                      restaurantProvider.searchResto(name),
                                )
                              : Text(
                                  'Recomended restaurants for you!',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
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
                    ? const Center(child: CircularProgressIndicator())
                    : restaurantProvider.restaurants!.isEmpty
                        ? Center(
                            child: Text(
                            'Not Found',
                            style: Theme.of(context).textTheme.bodyText2,
                          ))
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
      ),
    );
  }
}
