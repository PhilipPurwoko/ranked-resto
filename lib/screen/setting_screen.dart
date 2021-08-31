import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:rankedresto/functions/notification.dart';
import 'package:rankedresto/screen/dummy_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isReminderActive = false;

  @override
  Widget build(BuildContext context) {
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
                    AwesomeNotifications().cancelAllSchedules();
                  } else {
                    await activateDailyReminder();
                    final bool isHaveActionStream =
                        await AwesomeNotifications().actionStream.isEmpty;
                    if (isHaveActionStream) {
                      AwesomeNotifications().actionStream.listen(
                        (ReceivedAction notification) {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (BuildContext ctx) =>
                                  const DummyScreen(),
                            ),
                          );
                        },
                      );
                    }
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
  }
}
