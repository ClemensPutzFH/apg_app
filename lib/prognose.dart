import 'package:apg_app/main.dart';
import 'package:flutter/material.dart';

class Prognose extends StatelessWidget {
  late Future<SpitzenStundenObject> spitzenStundenData;
  Prognose(Future<SpitzenStundenObject> this.spitzenStundenData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0c1c2a),
        title: const Text('Prognose'),
      ),
      body: FutureBuilder<SpitzenStundenObject>(
        future: spitzenStundenData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.toJson().toString());
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF0c1c2a),
            ),
          );
        },
      ),
    );
  }
}
