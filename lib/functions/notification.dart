import 'dart:convert';
import 'dart:math';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rankedresto/functions/timer.dart';
import 'package:rankedresto/model/resto_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const int alarmId = 1;
const String localRestaurantIdKey = 'local_restaurant_id';
const String dailyReminderKey = 'is_daily_reminder_activated';

/// Schedule to run `createScheduledNotification` function at roughly 11:00 AM
/// and save random restaurant form given [restaurants] using shared preferences
Future<Duration> activateDailyNotification(List<Restaurant> restaurants) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(
    localRestaurantIdKey,
    restaurants.map((Restaurant restaurant) => restaurant.id).toList(),
  );
  final Duration alarmDuration = getDurationUntilNextTimeByHour(11);
  await AndroidAlarmManager.initialize();
  await AndroidAlarmManager.periodic(
    alarmDuration,
    alarmId,
    fireNotification,
  );
  return alarmDuration;
}

/// Create single notification of random restaurants from saved data using shared preferences
Future<void> fireNotification() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String> localRestaurantId =
      prefs.getStringList(localRestaurantIdKey) ?? <String>[];

  if (localRestaurantId.isEmpty) {
    return;
  }

  final String randomRestaurantId = (localRestaurantId..shuffle()).first;
  final Restaurant? restaurant = await getRestaurantById(randomRestaurantId);
  if (restaurant == null) {
    return;
  }

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: Random().nextInt(1000) + DateTime.now().microsecond,
      channelKey: 'scheduled_channel',
      title: 'Recomended Restaurant For You | ${restaurant.name}',
      body: restaurant.description,
      bigPicture: restaurant.pictureId,
      notificationLayout: NotificationLayout.BigPicture,
      payload: restaurant.toJson(),
    ),
  );
}

Future<void> disableDailyNotification() async {
  await AndroidAlarmManager.cancel(alarmId);
  await AwesomeNotifications().cancelAllSchedules();
}

/// Return bool which represent the daily reminder settings
Future<bool> getDailyReminderSettings() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(dailyReminderKey) ?? false;
}

Future<Restaurant?> getRestaurantById(String id) async {
  try {
    final Uri url = Uri.parse('https://restaurant-api.dicoding.dev/list');
    final http.Response res = await http.get(url);
    final Map<String, dynamic> data =
        json.decode(res.body) as Map<String, dynamic>;
    final RestoList restodata = RestoList.fromJson(data);
    return restodata.restaurants.firstWhere(
      (Restaurant restaurant) => restaurant.id == id,
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}
