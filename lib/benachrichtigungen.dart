import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import 'benachrichtigungstext.dart';
import 'information.dart';

import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
bool isNotificationOn = false;

class Benachrichtigungen extends StatefulWidget {
  const Benachrichtigungen({super.key});

  @override
  State<Benachrichtigungen> createState() => _BenachrichtigungenState();
}

class _BenachrichtigungenState extends State<Benachrichtigungen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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

                  print("Switchtile value: " + value.toString());
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
