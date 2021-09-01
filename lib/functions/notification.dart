import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:rankedresto/model/resto_list_model.dart';

Future<void> activateDailyReminder(List<Restaurant> restaurants) async {
  if (restaurants.isNotEmpty) {
    restaurants.shuffle();
    final Restaurant restaurant = restaurants.first;
    final String localTimeZoneIdentifier =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Random.secure().nextInt(1000),
        channelKey: 'basic_channel',
        title: 'Recomended Restaurant For You | ${restaurant.name}',
        body: restaurant.description,
        bigPicture: restaurant.pictureId,
        notificationLayout: NotificationLayout.BigPicture,
        payload: restaurant.toJson(),
      ),
      schedule: NotificationInterval(
        interval: 5,
        timeZone: localTimeZoneIdentifier,
        repeats: true,
      ),
    );
  }
}
