import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'ampel.dart';
import 'benachrichtigungen.dart';
import 'information.dart';
import 'prognose.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SpitzenStundenObject spitzenStundenData;

void main() async {
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFFdcdfe6),
            ledColor: Color(0xFFdcdfe6))
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);

  await inizializeService();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // red c6463c
  // green 51a672
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spitzenstunden',
      home: const MyHomePage(title: 'Spitzenstunden'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _counter = 0;
  late Future<SpitzenStundenObject> SpitzenStundenData;
  bool redTest = false;

  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  Future<void> _setState() async {
    setState(() {
      //TEST red after reload
      redTest = false;
    });

    return Future.delayed(Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0c1c2a),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          PopupMenuButton(
            itemBuilder: (itemContext) => [
              PopupMenuItem(
                child: Row(children: [
                  Icon(
                    Icons.percent,
                    color: Color(0xFF0c1c2a),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Prognose")
                ]),
                value: 1,
              ),
              PopupMenuItem(
                child: Row(children: [
                  Icon(
                    Icons.settings,
                    color: Color(0xFF0c1c2a),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Benachrichtigungen")
                ]),
                value: 2,
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Color(0xFF0c1c2a),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text("Information")
                  ],
                ),
                value: 3,
              ),
            ],
            onSelected: (menuItem) {
              if (menuItem == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Prognose(SpitzenStundenData)),
                );
              } else if (menuItem == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Benachrichtigungen()),
                );
              } else if (menuItem == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Information()),
                );
              }
            },
          )
        ],
      ),
      body: RefreshIndicator(
        color: Color(0xFF0c1c2a),
        onRefresh: _setState,
        child: FutureBuilder<SpitzenStundenObject>(
          future: fetchApgSpitzenApi(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.waiting) {
              if (snapshot.hasData) {
                DateTime now = DateTime.now();

                if (redTest) {
                  snapshot.data!.statusInfos.add(StatusInfos(
                      utc: now.add(Duration(seconds: 1)).toUtc().toString(),
                      status: "2"));
                }

                late final AnimationController _controller =
                    AnimationController(
                  duration: const Duration(seconds: 1),
                  vsync: this,
                );

                late final Animation<double> _animation = CurvedAnimation(
                  parent: _controller,
                  curve: Curves.easeIn,
                );

                for (var peakHoursObject in snapshot.data!.statusInfos) {
                  DateTime peakHourTimeStamp =
                      DateTime.parse(peakHoursObject.utc);
                  DateTime nowTimeStamp = DateTime.now();

                  print("Now: " + nowTimeStamp.toString());
                  print("Peak Hour:" + peakHourTimeStamp.toString());
                  print("Difference: " +
                      peakHourTimeStamp
                          .difference(nowTimeStamp)
                          .inHours
                          .toString());

                  print(" ");

                  if (peakHourTimeStamp.difference(nowTimeStamp).inHours == 0 &&
                      peakHoursObject.status == "2") {
                    _controller.forward();
                    return FadeTransition(
                      opacity: _animation,
                      child: SingleChildScrollView(
                        child: AmpelRed(),
                        physics: AlwaysScrollableScrollPhysics(),
                      ),
                    );
                  }
                }
                _controller.forward();
                return FadeTransition(
                    opacity: _animation,
                    child: SingleChildScrollView(
                      child: AmpelGreen(),
                      physics: AlwaysScrollableScrollPhysics(),
                    ));
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
            }

            // By default, show a loading spinner.
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF0c1c2a),
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<SpitzenStundenObject> fetchApgSpitzenApi() async {
  final response = await http
      .get(Uri.parse('https://awareness.cloud.apg.at/api/v1/PeakHourStatus'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //await Future.delayed(Duration(seconds: 5));
    spitzenStundenData =
        SpitzenStundenObject.fromJson(jsonDecode(response.body));
    return SpitzenStundenObject.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data from APG (Austrian Power Grid)');
  }
}

class SpitzenStundenObject {
  late String defaultStatus;
  late String firstUtc;
  late String lastUtc;
  late List<StatusInfos> statusInfos;

  SpitzenStundenObject(
      {required this.defaultStatus,
      required this.firstUtc,
      required this.lastUtc,
      required this.statusInfos});

  SpitzenStundenObject.fromJson(Map<String, dynamic> json) {
    defaultStatus = json['DefaultStatus'];
    firstUtc = json['FirstUtc'];
    lastUtc = json['LastUtc'];
    if (json['StatusInfos'] != null) {
      statusInfos = <StatusInfos>[];
      json['StatusInfos'].forEach((v) {
        statusInfos!.add(new StatusInfos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DefaultStatus'] = this.defaultStatus;
    data['FirstUtc'] = this.firstUtc;
    data['LastUtc'] = this.lastUtc;
    if (this.statusInfos != null) {
      data['StatusInfos'] = this.statusInfos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StatusInfos {
  late String utc;
  late String status;

  StatusInfos({required this.utc, required this.status});

  StatusInfos.fromJson(Map<String, dynamic> json) {
    utc = json['utc'];
    status = json['s'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['utc'] = this.utc;
    data['s'] = this.status;
    return data;
  }
}

Future<void> inizializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
      iosConfiguration: IosConfiguration(
          autoStart: true,
          onForeground: onStart,
          onBackground: onIosBackground),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart, isForegroundMode: true, autoStart: true));
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 2), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        //Foreground Notification
        service.setForegroundNotificationInfo(
            title: "Power watcher", content: "watching the power");
      }
    }

    if (DateTime.now().hour == 15) {
      SpitzenStundenObject spitzenStunden = await fetchApgSpitzenApi();

      await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: Random().nextInt(100),
              channelKey: 'basic_channel',
              title: 'Spitzenstunde voraus!',
              body: 'Heute um 8 - 14 Uhr ist eine Stromspitzenstunde.',
              actionType: ActionType.Default),
          schedule: NotificationCalendar.fromDate(
              date: DateTime.now().add(Duration(seconds: 10))));
      print("Now");
    }

    print("Background service running");
  });
}
