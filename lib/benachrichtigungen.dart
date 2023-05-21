import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:settings_ui/settings_ui.dart';

import 'benachrichtigungstext.dart';
import 'information.dart';

import 'package:shared_preferences/shared_preferences.dart';

//test

late SharedPreferences prefs;

class Benachrichtigungen extends StatefulWidget {
  const Benachrichtigungen({super.key});

  @override
  State<Benachrichtigungen> createState() => _BenachrichtigungenState();
}

class _BenachrichtigungenState extends State<Benachrichtigungen> {
  @override
  Future<void> initState() async {
    prefs = await SharedPreferences.getInstance();
    super.initState();
  }

  bool isNotificationOn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0c1c2a),
        title: const Text('Einstellungen'),
      ),
      body: SettingsList(sections: [
        SettingsSection(
          tiles: [
            SettingsTile.switchTile(
                initialValue: isNotificationOn,
                onToggle: (value) async {
                  setState(() {
                    isNotificationOn = value;
                  });

                  if (value) {
                    FlutterBackgroundService().invoke("setAsBackground");

                    /*
                    AwesomeNotifications().createNotification(
                        content: NotificationContent(
                            id: 10,
                            channelKey: 'basic_channel',
                            title: 'Spitzenstunde voraus!',
                            body:
                                'Heute um 8 - 14 Uhr ist eine Stromspitzenstunde.',
                            actionType: ActionType.Default),
                        schedule: NotificationCalendar.fromDate(
                            date: DateTime.now().add(Duration(seconds: 10))));

                            */
                  }
                },
                title: Text("Benachrichtigungen")),
            SettingsTile.navigation(
              title: Text("Text bei Benachrichtigung"),
              onPressed: (value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Benachrichtigungstext()),
                );
              },
            )
          ],
        )
      ]),
    );
  }
}
