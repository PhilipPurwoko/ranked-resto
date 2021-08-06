import 'dart:convert';

import 'package:flutter/material.dart';
import 'database.dart';

void main() {
  runApp(RankedResto());
}

class RankedResto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ranked Resto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Restaurant>> fetchRestaurant() async {
    final String res =
        await DefaultAssetBundle.of(context).loadString('data.json');
    final data = json.decode(res) as Map<String, dynamic>;
    return Database.fromJson(data).restaurants;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ranked Resto'),
      ),
      body: FutureBuilder(
        future: fetchRestaurant(),
        builder: (_, AsyncSnapshot<List<Restaurant>> restaurants) {
          if (restaurants.hasData) {
            return ListView.builder(
              itemCount: restaurants.data!.length,
              itemBuilder: (_, int index) => ListTile(
                title: Text(restaurants.data![index].name),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
