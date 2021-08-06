import 'package:flutter/material.dart';
import 'resto_list.dart';
import 'resto_detail.dart';

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
      initialRoute: RestoList.routeName,
      routes: {
        RestoList.routeName: (_) => RestoList(),
        RestoDetail.routeName: (_) => RestoDetail(),
      },
    );
  }
}