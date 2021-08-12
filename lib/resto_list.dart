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
  bool _searchMode = false;
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
        appBar: AppBar(
          leading: _searchMode
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    restaurantProvider.resetResto();
                    setState(() {
                      _searchMode = !_searchMode;
                    });
                  },
                  icon: const Icon(Icons.arrow_back),
                )
              : null,
          title: _searchMode
              ? TextField(
                  controller: _searchController,
                  focusNode: focusNode,
                  autofocus: true,
                  cursorColor: const Color(0xFF98ee99),
                  // style: const TextStyle(color: Color(0xFF98ee99)),
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
              : const Text('Ranked Resto'),
          actions: <IconButton>[
            if (!_searchMode)
              IconButton(
                onPressed: () {
                  setState(() {
                    _searchMode = !_searchMode;
                  });
                },
                icon: const Icon(Icons.search),
              ),
          ],
        ),
        body: SafeArea(
          child: restaurantProvider.restaurants == null
              ? const Center(child: CircularProgressIndicator())
              : restaurantProvider.restaurants!.isEmpty
                  ? const Center(child: Text('Not Found'))
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: restaurantProvider.restaurants!.length,
                      itemBuilder: (_, int index) => RestoCard(
                        restaurantProvider.restaurants![index],
                      ),
                    ),
        ),
      ),
    );
  }
}
