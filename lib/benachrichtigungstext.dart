import 'package:flutter/material.dart';

class Benachrichtigungstext extends StatelessWidget {
  const Benachrichtigungstext({super.key});

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
                  TextField(keyboardType: TextInputType.multiline, maxLines: 4)
                ],
              ),
              width: MediaQuery.of(context).size.width * 0.85,
            ),
            Spacer()
          ],
        ));
  }
}
