import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rankedresto/screen/resto_detail_screen.dart';
import 'package:rankedresto/screen/resto_list_screen.dart';

import 'theme.dart';

void main() {
  runApp(ProviderScope(child: RankedResto()));
}

class RankedResto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ranked Resto',
      debugShowCheckedModeBanner: false,
      theme: theme,
      initialRoute: RestoList.routeName,
      routes: <String, Widget Function(BuildContext)>{
        RestoList.routeName: (_) => RestoList(),
        RestoDetailScreen.routeName: (_) => const RestoDetailScreen(),
      },
    );
  }
}
