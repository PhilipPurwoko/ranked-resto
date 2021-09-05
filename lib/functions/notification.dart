import 'dart:convert';
import 'dart:math';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rankedresto/model/resto_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const int alarmId = 1;
const String localRestaurantIdKey = 'local_restaurant_id';

Future<void> activateDailyNotification(List<Restaurant> restaurants) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(
    localRestaurantIdKey,
    restaurants.map((Restaurant restaurant) => restaurant.id).toList(),
  );
  await AndroidAlarmManager.initialize();
  await AndroidAlarmManager.periodic(
    const Duration(seconds: 5),
    alarmId,
    createScheduledNotification,
  );
}

Future<void> createScheduledNotification() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String> localRestaurantId =
      prefs.getStringList(localRestaurantIdKey) ?? <String>[];
  if (localRestaurantId.isEmpty) {
    return;
  }
  final String localTimeZoneIdentifier =
      await AwesomeNotifications().getLocalTimeZoneIdentifier();
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
    schedule: NotificationInterval(
      interval: 5,
      timeZone: localTimeZoneIdentifier,
    ),
  );
}

Future<void> disableDailyNotification() async {
  await AndroidAlarmManager.cancel(alarmId);
  await AwesomeNotifications().cancelAllSchedules();
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
