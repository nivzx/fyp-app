import 'package:flutter/material.dart';
import 'package:g/services/api_service.dart';
import 'package:g/services/signal_service.dart';
import './services/location_service.dart';

import './widgets/signal_box.dart';
import './widgets/location_box.dart';

import 'dart:async';

import 'package:carrier_info/carrier_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

void main() {
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
  Timer? timer;
  double signalLevel = 0;
  late Position position;
  late StreamSubscription<Position> positionStream;
  double lat = 0.0, long = 0.0;

  IosCarrierData? _iosInfo;
  IosCarrierData? get iosInfo => _iosInfo;
  set iosInfo(IosCarrierData? iosInfo) {
    setState(() => _iosInfo = iosInfo);
  }

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

    Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => {
        getLocation(),
        getSignalStrength(),
        // ApiService.sendDatatoAPI(lat, long, signalLevel)
      },
    );
  }

  getLocation() async {
    Position currentPosition = await LocationService.getRandomPosition();

    setState(() {
      lat = currentPosition.latitude;
      long = currentPosition.longitude;
    });
  }

  getSignalStrength() async {
    double signalStrength = await SignalService.getRandomStrength();

    setState(() {
      signalLevel = signalStrength;
    });
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
        body: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              SignalBox(signalLevel: signalLevel),
              const SizedBox(
                height: 20,
              ),
              LocationBox(lat: lat, long: long),
              ...(androidInfo?.telephonyInfo ?? []).map((it) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    children: [
                      Text(
                        'Service Provider: ${it.displayName}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
