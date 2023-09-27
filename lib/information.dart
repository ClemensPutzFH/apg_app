import 'package:flutter/material.dart';
// ignore: unnecessary_import

class Information extends StatelessWidget {
  const Information({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0c1c2a),
        title: const Text('Information'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: [
                Container(
                  height: 30,
                ),
                Text("APG Powermonitor",
                    style:
                        TextStyle(fontSize: 33, fontWeight: FontWeight.bold)),
                Container(
                  height: 30,
                ),
                Text(
                    textAlign: TextAlign.justify,
                    "Der APG Powermonitor schafft Orientierung in Zeiten der Energiekrise. Daten und Fakten rund um die Stromversorgung sind dafür zentral."),
                Container(
                  height: 20,
                ),
                Text(
                    textAlign: TextAlign.justify,
                    "Der Hintergrund: Die sichere Stromversorgung ist eine wesentliche Grundlage für die Sicherheit und das Wohlergehen unserer Gesellschaft. Geopolitische Entwicklungen rund um den Angriffskrieg Russlands gegen die Ukraine, Reduktion der verfügbaren grundlastfähigen Kraftwerke in Europa, Ausbau der Erneuerbaren, Extremwetterperioden stellen für die sichere Stromversorgung Österreichs große Herausforderungen dar. Aufgrund der zentralen Lage ist Österreich von all diesen Entwicklungen direkt oder indirekt betroffen. Gebot der Stunde ist der sorgsame Umgang mit Strom. Neben dem Ausbau des Stromnetzes und der sicheren Transformation des Energiesystems ist in Zeiten der Energiekrise daher auch die Entlastung des Stromnetzes durch Energiesparen essenziell. Der APG Powermonitor schafft Orientierung in einer nachhaltig herausfordernden energiewirtschaftlichen Zeit. Mit ihm wird ein umfassendes Lagebild zur Versorgungssicherheit Österreichs geschaffen."),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
