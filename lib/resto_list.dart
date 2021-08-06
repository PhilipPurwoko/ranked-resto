import 'dart:convert';
import 'package:flutter/material.dart';
import 'database.dart';
import 'resto_card.dart';

class RestoList extends StatefulWidget {
  static const String routeName = 'resto-list';
  @override
  _RestoListState createState() => _RestoListState();
}

class _RestoListState extends State<RestoList> {
  Future<List<Restaurant>> fetchRestaurant() async {
    final String res =
        await DefaultAssetBundle.of(context).loadString('data.json');
    final data = json.decode(res) as Map<String, dynamic>;
    return Database.fromJson(data).restaurants;
  }

  @override
  Widget build(BuildContext context) {
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
                        child: Text('Recomended restaurants for you!'),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.search),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: fetchRestaurant(),
                builder: (_, AsyncSnapshot<List<Restaurant>> restaurants) {
                  if (restaurants.hasData) {
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: restaurants.data!.length,
                      itemBuilder: (_, int index) =>
                          RestoCard(restaurants.data![index]),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
