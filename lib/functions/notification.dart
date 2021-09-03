import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rankedresto/model/resto_list_model.dart';
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
          'scheduled_name',
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

Future<void> selectedNotification(String? payload) async {}

Future<void> disableDailyReminder() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.cancelAll();
}
