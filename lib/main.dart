import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:g/services/api_service.dart';
import 'package:g/services/signal_service.dart';
import './services/location_service.dart';

import './widgets/signal_box.dart';
import './widgets/location_box.dart';
import './widgets/map.dart';

import 'dart:async';

import 'package:carrier_info/carrier_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'api/firebase_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();

  final RemoteMessage? remoteMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double? latitude;
  double? longitude;
  double? signalStrength;
  late Timer dataUpdateTimer;
  late Timer firebaseUpdateTimer;
  int signalLevel = 0;
  late Position position;
  late StreamSubscription<Position> positionStream;
  double lat = 0.0, long = 0.0;

  IosCarrierData? _iosInfo;
  IosCarrierData? get iosInfo => _iosInfo;
  set iosInfo(IosCarrierData? iosInfo) {
    setState(() => _iosInfo = iosInfo);
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AndroidCarrierData? _androidInfo;
  AndroidCarrierData? get androidInfo => _androidInfo;
  set androidInfo(AndroidCarrierData? carrierInfo) {
    setState(() => _androidInfo = carrierInfo);
  }

  @override
  void initState() {
    super.initState();
    getLocation();

    getSignalStrength();
    initPlatformState();

    dataUpdateTimer = Timer.periodic(
      const Duration(seconds: 10),
      (Timer t) => updateData(),
    );

    firebaseUpdateTimer = Timer.periodic(
      const Duration(seconds: 15),
      (Timer t) => updateFirebaseData(),
    );
  }

  void updateData() async {
    await getLocation();
    await getSignalStrength();

    if (lat != 0 && long != 0 && signalLevel != 0) {
      await ApiService.sendDatatoAPI(lat, long, signalLevel);
    }
  }

  void updateFirebaseData() async {
    if (lat != 0 && long != 0) {
      String? token = await FirebaseApi().getToken();
      await ApiService.sendTokenLocation(token, lat, long);
    }
  }

  getLocation() async {
    Position currentPosition = await LocationService.getCurrentPosition();

    setState(() {
      lat = currentPosition.latitude;
      long = currentPosition.longitude;
    });
  }

  getSignalStrength() async {
    int signalStrength = await SignalService.getSignalStrength();

    setState(() {
      signalLevel = signalStrength;
    });
  }

  Widget buildMapWidget() {
    return lat == 0 && long == 0
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : GoogleMapWidget(initialLat: lat, initialLong: long);
  }

  Widget buildServiceProviderText() {
    return Text(
      'Service Provider: ${androidInfo!.telephonyInfo[0].displayName}',
      style: const TextStyle(
        fontSize: 15,
        color: CupertinoColors.systemGrey,
      ),
    );
  }

  void sendDatatoAPIWithFixedValue() {
    ApiService.sendDatatoAPI(lat, long, -20);
  }

  Future<void> initPlatformState() async {
    // Ask for permissions before requesting data
    await [
      Permission.locationWhenInUse,
      Permission.phone,
      Permission.sms,
    ].request();

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      if (Platform.isAndroid) androidInfo = await CarrierInfo.getAndroidInfo();
      if (Platform.isIOS) iosInfo = await CarrierInfo.getIosInfo();
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromRGBO(211, 237, 254, 1)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: const Text('SignalSpotter'),
            titleSpacing: 00.0,
            centerTitle: true,
            toolbarHeight: 100.2,
            toolbarOpacity: 0.8,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(55),
                  bottomLeft: Radius.circular(55)),
            ),
            elevation: 0.00,
            backgroundColor: const Color.fromARGB(240, 3, 45, 69),
          ),
          body: Stack(children: [
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SignalBox(signalLevel: signalLevel),
                      LocationBox(lat: lat, long: long),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(child: buildMapWidget()),
                  if (androidInfo != null &&
                      androidInfo!.telephonyInfo.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: buildServiceProviderText(),
                    ),
                ],
              ),
            ),
            Positioned(
              bottom: 60, // Adjust the value for vertical positioning
              left: 16, // Adjust the value for horizontal positioning
              child: ElevatedButton(
                onPressed: sendDatatoAPIWithFixedValue,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                  primary: Colors.red,
                ),
                child: const Icon(
                  Icons.warning,
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ])),
    );
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel', // id
      'High Importance Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Test Notification',
      'This is a test notification.',
      platformChannelSpecifics,
    );
  }
}
