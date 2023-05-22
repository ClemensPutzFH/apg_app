import 'package:flutter/material.dart';

class Benachrichtigungstext extends StatefulWidget {
  const Benachrichtigungstext({super.key});

  @override
  State<Benachrichtigungstext> createState() => _BenachrichtigungstextState();
}

class _BenachrichtigungstextState extends State<Benachrichtigungstext> {
  late TextEditingController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = new TextEditingController(text: 'Initial value');
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
