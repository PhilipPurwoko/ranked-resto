import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'resto_detail.dart';
import 'resto_list.dart';
import 'resto_provider.dart';
import 'theme.dart';

void main() {
  runApp(RankedResto());
}

class RankedResto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <ChangeNotifierProvider<ChangeNotifier>>[
        ChangeNotifierProvider<RestaurantProvider>(
          create: (_) => RestaurantProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Ranked Resto',
        debugShowCheckedModeBanner: false,
        theme: theme,
        initialRoute: RestoList.routeName,
        routes: <String, Widget Function(BuildContext)>{
          RestoList.routeName: (_) => RestoList(),
          RestoDetail.routeName: (_) => const RestoDetail(),
        },
      ),
    );
  }
}
