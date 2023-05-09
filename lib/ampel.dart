import 'package:apg_app/information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AmpelGreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AmpelBuilder(
      resImage: 'lib/res/green-austria.png',
      status: "Normal",
      statusColor: 0xFF51a672,
      descHeadline: "Aktuell besteht kein Grund zur Besorgnis",
      description:
          "Es ist ausreichend Strom verfügbar, der zu einem hohen Anteil aus erneuerbaren Quellen wie Wasser, Wind, Biomasse und Sonne zur Verfügung gestellt werden kann. /n Sie helfen mit, das Stromsystem zu entlasten und den Gasverbrauch zu reduzieren, wenn Sie Tätigkeiten mit Stromverbrauch von den Hochlaststunden in den grünen Normallastbereich legen, z.B. Waschmaschine, Trockner, Geschirrspüler, Auto aufladen usw.",
    );
  }
}

class AmpelRed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AmpelBuilder(
      resImage: 'lib/res/red-austria.png',
      status: "Hochlast",
      statusColor: 0xFFc6463c,
      descHeadline: "Aktuell liegt eine hohe Last auf dem Stromnetz",
      description:
          "Das österreichische Stromsystem ist stark belastet. Wir müssen daher mehr Strom aus dem Ausland nach Österreich importieren und mehr fossiles Gas in Kraftwerken verbrennen. Sie helfen mit, das Stromsystem zu entlasten und den Gasverbrauch zu reduzieren, wenn Sie Tätigkeiten mit Stromverbrauch von den Hochlaststunden in den grünen Normallastbereich verschieben, z.B. Waschmaschine, Trockner, Geschirrspüler, Auto aufladen usw.",
    );
  }
}

//'lib/res/green-austria.png'
//"Aktuell besteht kein Grund zur Besorgnis"
//"Normal"
//                    "Es ist ausreichend Strom verfügbar, der zu einem hohen Anteil aus erneuerbaren Quellen wie Wasser, Wind, Biomasse und Sonne zur Verfügung gestellt werden kann. /n Sie helfen mit, das Stromsystem zu entlasten und den Gasverbrauch zu reduzieren, wenn Sie Tätigkeiten mit Stromverbrauch von den Hochlaststunden in den grünen Normallastbereich legen, z.B. Waschmaschine, Trockner, Geschirrspüler, Auto aufladen usw."

class AmpelBuilder extends StatelessWidget {
  final String resImage;
  final String status;
  final String descHeadline;
  final String description;
  final int statusColor;

  AmpelBuilder(
      {required this.resImage,
      required this.status,
      required this.statusColor,
      required this.descHeadline,
      required this.description});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: Row(
        children: [
          Spacer(),
          Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.15,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.80,
                  height: MediaQuery.of(context).size.width * 0.80,
                  decoration: BoxDecoration(
                      color: Color(0xFFdcdfe6),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage(resImage)),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.07,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.15,
                            0,
                            MediaQuery.of(context).size.width * 0.15,
                            0),
                        child: FittedBox(
                          child: Text(
                            status,
                            style: TextStyle(
                                color: Color(statusColor), fontSize: 3300),
                          ),
                        ),
                      )
                      //Text(snapshot.data!.lastUtc)
                    ],
                  )),
              SizedBox(height: MediaQuery.of(context).size.width * 0.15),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  children: [
                    FittedBox(
                      child: Text(
                        descHeadline,
                        style: TextStyle(
                            fontSize: 3000, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.04,
                    ),
                    Text(description),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacer()
        ],
      ),
    );
  }
}
