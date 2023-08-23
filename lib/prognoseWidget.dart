import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:apg_app/benachrichtigungstext.dart';
import 'package:apg_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:http/http.dart' as http;

import 'ampel.dart';
import 'benachrichtigungen.dart';
import 'information.dart';
import 'prognose.dart';

import 'package:flutter_background_service_android/flutter_background_service_android.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrognoseView extends StatelessWidget {
  SpitzenStundenObject data;
  PrognoseView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    DateTime firstUtc = DateTime.parse(data.firstUtc);
    DateTime lastUtc = DateTime.parse(data.lastUtc);

    var test = lastUtc.difference(firstUtc).inHours;

    print("Day: " + firstUtc.toLocal().weekday.toString());

    List<Widget> prognoseDays = List<Widget>.empty(growable: true);
    List<Widget> hourTiles = List<Widget>.empty(growable: true);

    for (var i = 1; i <= lastUtc.difference(firstUtc).inHours; i++) {
      var iTime = firstUtc.add(Duration(hours: i - 1));
      bool tileStatusOrange = false;
      data.statusInfos.forEach((element) {
        if (DateTime.parse(element.utc).difference(iTime).inHours == 0) {
          tileStatusOrange = true;
        }
      });

      hourTiles.add(getHourTile(
          tileStatusOrange,
          i,
          DateTime.now().difference(iTime).inMinutes < 60 &&
              DateTime.now().difference(iTime).inMinutes > 0));

      if (i % 24 == 0) {
        prognoseDays.add(getPrognoseRow(context, List.from(hourTiles),
            iTime.weekday, prognoseDays.length == 0));
        hourTiles = List<Widget>.empty(growable: true);
      }
    }

    return Column(
      children: [
        Padding(
          child: Text(
            "Prognose",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
        ),
        Container(
          child: Column(
            children: prognoseDays,
          ),
        ),
        Container(
          height: 30,
        )
      ],
    );
  }
}

Widget getPrognoseRow(context, List<Widget> rowTileList, day, isToday) {
  if (isToday) {
    day = 10;
  }

  return LayoutBuilder(
    builder: (BuildContext buildContext, BoxConstraints constraints) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.075,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Text(getWeekday(day),
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Spacer()
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.075,
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        width: 510,
                        height: 30.0,
                        decoration: BoxDecoration(),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '0 Uhr',
                            ),
                            Text(
                              ' 4 Uhr',
                            ),
                            Text(
                              ' 8 Uhr',
                            ),
                            Text(
                              '  12 Uhr',
                            ),
                            Text(
                              '16 Uhr',
                            ),
                            Text(
                              '20 Uhr',
                            ),
                            Text(
                              '24 Uhr',
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: rowTileList,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.075,
                )
              ],
            ),
          )
        ],
      );
    },
  );
}

Widget getHourTile(orangeStatus, tileNumber, isNow) {
  Color tileColor = Color(0xFF51a672);
  if (orangeStatus) {
    tileColor = Color(0xFFc6463c);
  }

  var showTriangle = false;

  showTriangle = (tileNumber - 1) % 4 == 0;

  return Container(
    child: Column(
      children: [
        Opacity(
          opacity: showTriangle ? 1.0 : 0.0,
          child: Transform.translate(
            offset: Offset(-10, 0),
            child: Transform.rotate(
              angle: 3.1415,
              child: CustomPaint(
                size: Size(13, 13),
                painter: TrianglePainter(
                  strokeColor: Color(0xFF0c1c2a),
                  strokeWidth: 10,
                  paintingStyle: PaintingStyle.fill,
                ),
              ),
            ),
          ),
        ),
        Container(
          width: 20.0,
          height: 50.0,
          child: Opacity(
            opacity: isNow ? 1.0 : 0.0,
            child: Container(
              width: 0.5,
              height: 0.5,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFFFFF),
                  border: Border.all(
                    color: Color(0xFF0c1c2a),
                  )),
            ),
          ),
          decoration: BoxDecoration(
            color: tileColor,
            shape: BoxShape.rectangle,
            border: Border.all(
              color: Color(0xFF0c1c2a),
            ),
          ),
        ),
      ],
    ),
  );
}

String getWeekday(int day) {
  switch (day) {
    case 1:
      {
        return "Montag";
      }

    case 2:
      {
        return "Dienstag";
      }

    case 3:
      {
        return "Mittwoch";
      }

    case 4:
      {
        return "Donnerstag";
      }

    case 5:
      {
        return "Freitag";
      }
    case 6:
      {
        return "Samstag";
      }
    case 7:
      {
        return "Sonntag";
      }
    case 10:
      {
        return "Heute";
      }

    default:
      {
        return "Error";
      }
  }
}

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter(
      {this.strokeColor = Colors.black,
      this.strokeWidth = 3,
      this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
