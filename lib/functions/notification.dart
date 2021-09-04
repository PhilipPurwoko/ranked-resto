import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rankedresto/model/resto_detail_model.dart';
import 'package:rankedresto/model/resto_list_model.dart';
import 'package:rankedresto/screen/detail_screen.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

Future<void> makeScheduledNotification(List<Restaurant> restaurants) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  if (restaurants.isNotEmpty) {
    final Restaurant restaurant = (restaurants..shuffle()).first;
    tz.initializeTimeZones();
    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'Recomended Restaurant For You | ${restaurant.name}',
      restaurant.description,
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 3)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '1',
          'scheduled_channel',
          'Channel for scheduled notification',
          importance: Importance.high,
        ),
      ),
      androidAllowWhileIdle: true,
      payload: restaurant.toJson().toString(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}

Future<void> selectedNotification(BuildContext context, String? payload) async {
  final Restaurant restaurant = Restaurant.fromJson(
    json.decode(payload!) as Map<String, dynamic>,
  );

  Navigator.of(context).pushNamed(
    DetailScreen.routeName,
    arguments: RestaurantDetail(
      id: restaurant.id,
      name: restaurant.name,
      description: restaurant.description,
      city: restaurant.city,
      pictureId: restaurant.pictureId,
      rating: restaurant.rating,
    ),
  );
}

Future<void> disableDailyReminder() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.cancelAll();
}
