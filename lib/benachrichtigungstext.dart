import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const benachrichtigungsTextKey = "benachrichtigungsTextKey";

class Benachrichtigungstext extends StatefulWidget {
  const Benachrichtigungstext({super.key});

  @override
  State<Benachrichtigungstext> createState() => _BenachrichtigungstextState();
}

class _BenachrichtigungstextState extends State<Benachrichtigungstext> {
  late TextEditingController _controller;
  @override
  void initState() {
    _controller = new TextEditingController();
    // TODO: implement initState
    getInitialTextfieldValue(benachrichtigungsTextKey, _controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF0c1c2a),
          title: const Text('Text bei Benachrichtigung'),
        ),
        body: Row(
          children: [
            Spacer(),
            SizedBox(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                      onChanged: (text) {
                        pref_setString(benachrichtigungsTextKey, text);
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      controller: _controller)
                ],
              ),
              width: MediaQuery.of(context).size.width * 0.85,
            ),
            Spacer()
          ],
        ));
  }
}

void getInitialTextfieldValue(
    String key, TextEditingController controller) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  controller.text = prefs.getString(key) ?? "";
}

void pref_setString(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}
