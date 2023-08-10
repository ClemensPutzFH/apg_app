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
      var iTime = lastUtc.toLocal().add(Duration(hours: i));

      hourTiles.add(getHourTile(1));

      if (i % 24 == 0) {
        prognoseDays
            .add(getPrognoseRow(context, List.from(hourTiles), iTime.weekday));
        hourTiles = List<Widget>.empty(growable: true);
      }
    }

    return Column(
      children: prognoseDays,
    );
  }
}

Widget getPrognoseRow(context, List<Widget> rowTileList, day) {
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
              Text(
                'Heute',
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
                              ' 0 Uhr',
                            ),
                            Text(
                              ' 4 Uhr',
                            ),
                            Text(
                              ' 8 Uhr',
                            ),
                            Text(
                              '12 Uhr',
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

Widget getHourTile(status) {
  return Container(
    width: 20.0,
    height: 50.0,
    decoration: BoxDecoration(
      color: Color(0xFFFF00FF),
      shape: BoxShape.rectangle,
      border: Border.all(
        color: Color(0xFF00FFFF),
      ),
    ),
  );
}
