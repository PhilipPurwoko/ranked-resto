import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rankedresto/functions/navigation.dart';
import 'package:rankedresto/model/resto_list_model.dart';
import 'package:rankedresto/screen/detail_screen.dart';
import 'package:rankedresto/screen/nav_screen.dart';
import 'package:rankedresto/theme.dart';

Future<void> main() async {
  await AwesomeNotifications().initialize(null, <NotificationChannel>[
    NotificationChannel(
      channelKey: 'scheduled_channel',
      channelName: 'Scheduled Notifications',
      importance: NotificationImportance.High,
    ),
  ]);

  final NavigationService navigatorService = NavigationService();
  AwesomeNotifications().actionStream.listen(
    (ReceivedAction notification) {
      final Restaurant restaurant = Restaurant.fromJson(notification.payload!);
      navigatorService.navigateToDetailScreen(restaurant);
    },
  );

  runApp(
    ProviderScope(
      child: RankedResto(navigatorService),
    ),
  );
}

class RankedResto extends StatelessWidget {
  const RankedResto(this.navigatorService);
  final NavigationService navigatorService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      title: 'Ranked Resto',
      navigatorKey: navigatorService.navigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: NavScreen.routeName,
      routes: <String, Widget Function(BuildContext)>{
        NavScreen.routeName: (_) => NavScreen(),
        DetailScreen.routeName: (_) => const DetailScreen(),
      },
    );
  }
}
