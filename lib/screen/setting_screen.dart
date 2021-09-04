import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rankedresto/functions/notification.dart';
import 'package:rankedresto/provider/list_provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isReminderActive = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext ctx, ScopedReader watch, _) {
      final ListProvider listProviderState = watch<ListProvider>(listProvider);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Daily Recomendation'),
                Switch.adaptive(
                  value: isReminderActive,
                  onChanged: (_) async {
                    if (isReminderActive) {
                      await AwesomeNotifications().cancelAllSchedules();
                      debugPrint('Scedhuled disabled');
                    } else {
                      await createScheduledNotification(
                        listProviderState.restaurants,
                      );
                      debugPrint('Scedhuled activated');
                    }

                    setState(() {
                      isReminderActive = !isReminderActive;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
