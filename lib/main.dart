import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rankedresto/screen/detail_screen.dart';
import 'package:rankedresto/screen/nav_screen.dart';
import 'package:rankedresto/theme.dart';

void main() {
  AwesomeNotifications().initialize(
    null,
    <NotificationChannel>[
      NotificationChannel(
        channelShowBadge: true,
        channelKey: 'basic_channel',
        channelName: 'Basic Notification',
        importance: NotificationImportance.High,
      ),
    ],
  );
  runApp(ProviderScope(child: RankedResto()));
}

class RankedResto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ranked Resto',
      debugShowCheckedModeBanner: false,
      theme: theme,
      initialRoute: NavScreen.routeName,
      routes: <String, Widget Function(BuildContext)>{
        NavScreen.routeName: (_) => NavScreen(),
        DetailScreen.routeName: (_) => const DetailScreen(),
      },
    );
  }
}
