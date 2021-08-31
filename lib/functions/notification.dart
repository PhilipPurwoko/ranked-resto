import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> activateDailyReminder() async {
  final String localTimeZoneIdentifier =
      await AwesomeNotifications().getLocalTimeZoneIdentifier();

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: Random.secure().nextInt(1000),
      channelKey: 'basic_channel',
      title: 'Recomended Restaurant For You',
      body: 'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum',
      bigPicture: 'asset://assets/placeholder.png',
      notificationLayout: NotificationLayout.BigPicture,
    ),
    schedule: NotificationInterval(
      interval: 5,
      timeZone: localTimeZoneIdentifier,
      repeats: true,
    ),
  );
}
