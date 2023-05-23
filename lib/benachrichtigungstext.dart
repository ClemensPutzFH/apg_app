import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String key = "benachrichtigungsTextKey";

class Benachrichtigungstext extends StatefulWidget {
  const Benachrichtigungstext({super.key});

  @override
  State<Benachrichtigungstext> createState() => _BenachrichtigungstextState();
}

class _BenachrichtigungstextState extends State<Benachrichtigungstext> {
  late TextEditingController _controller;
  String initString;
  @override
  void initState() {
    // TODO: implement initState
    getSharedPreferences();
    super.initState();
    _controller = new TextEditingController(text: );
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
                        prefs.setString(key, text);
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

void getInitialTextfieldValue() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initString = prefs.getString(key);
}