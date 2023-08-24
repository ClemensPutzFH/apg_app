import 'package:apg_app/main.dart';
import 'package:apg_app/prognoseWidget.dart';
import 'package:flutter/material.dart';

class Prognose extends StatelessWidget {
  SpitzenStundenObject spitzenStundenData;
  Prognose(SpitzenStundenObject this.spitzenStundenData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF0c1c2a),
          title: const Text('Prognose'),
        ),
        body: SingleChildScrollView(
            child: PrognoseView(data: spitzenStundenData)));
  }
}
