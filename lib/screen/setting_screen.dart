import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rankedresto/functions/notification.dart';
import 'package:rankedresto/provider/list_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                FutureBuilder<bool>(
                    future: getDailyReminderSettings(),
                    builder: (
                      _,
                      AsyncSnapshot<bool> isDailyReminderActivated,
                    ) {
                      if (!isDailyReminderActivated.hasData) {
                        return const CircularProgressIndicator();
                      } else {
                        return Switch.adaptive(
                          value: isDailyReminderActivated.data!,
                          onChanged: (_) async {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            if (isDailyReminderActivated.data!) {
                              await disableDailyNotification();
                              await prefs.setBool(dailyReminderKey, false);
                            } else {
                              await activateDailyNotification(
                                listProviderState.restaurants,
                              );
                              await prefs.setBool(dailyReminderKey, true);
                              debugPrint('Scedhuled activated');
                            }

                            setState(() {
                              isReminderActive = isDailyReminderActivated.data!;
                              isReminderActive = !isReminderActive;
                            });
                          },
                        );
                      }
                    }),
              ],
            ),
          ],
        ),
      );
    });
  }
}
