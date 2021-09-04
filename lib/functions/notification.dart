import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:rankedresto/model/resto_list_model.dart';

Future<void> createScheduledNotification(List<Restaurant> restaurants) async {
  final String localTimeZoneIdentifier =
      await AwesomeNotifications().getLocalTimeZoneIdentifier();
  final Restaurant restaurant = (restaurants..shuffle()).first;

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
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
