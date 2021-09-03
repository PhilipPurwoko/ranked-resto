import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rankedresto/functions/notification.dart';
import 'package:rankedresto/screen/detail_screen.dart';
import 'package:rankedresto/screen/nav_screen.dart';
import 'package:rankedresto/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: selectedNotification,
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
