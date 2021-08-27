import 'package:flutter/material.dart';

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
              const Text('Daily Reminder'),
              Switch.adaptive(
                value: isReminderActive,
                onChanged: (_) {
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
