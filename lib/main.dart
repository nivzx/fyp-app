import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:carrier_info/carrier_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:gsm_info/gsm_info.dart';
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
  late IO.Socket socket;
  double? latitude;
  double? longitude;
  double? signalStrength;
  Timer? timer;
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  int _signal_strength = 0;
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

    sleep(const Duration(seconds: 20));
    getsignal_strength();

    initSocket();
    initPlatformState();

    timer = Timer.periodic(
        const Duration(seconds: 5), (Timer t) => sendDatatoServer());
  }

  sendDatatoServer() {
    var dataComb = {"lat": lat, "long": long, "signal": _signal_strength};

    socket.emit('data-retrieve', jsonEncode(dataComb));
  }

  getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    var geolocator = Geolocator();
    var locationOptions = const LocationSettings(
        accuracy: LocationAccuracy.high, distanceFilter: 1);

    positionStream =
        Geolocator.getPositionStream(locationSettings: locationOptions)
            .listen((Position position) {
      if (position != null) {
        setState(() {
          lat = position.latitude;
          long = position.longitude;
        });
      } else {
        setState(() {
          lat = 0.0;
          long = 0.0;
        });
      }
    });
  }

  getSignal() {
    getsignal_strength();
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

  Future<void> initSocket() async {
    try {
      socket = IO.io("http://172.20.10.8:3700", <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });

      socket.connect();
      socket.onConnect((data) => {});
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  Future<void> getsignal_strength() async {
    int signal_strength = 0;
    try {
      signal_strength = await GsmInfo.gsmSignalDbM;
      print(signal_strength);
    } on PlatformException {
      signal_strength = -999;
    }
    if (!mounted) return;

    setState(() {
      _signal_strength = signal_strength;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(scaffoldBackgroundColor: Color.fromRGBO(211, 237, 254, 1)),
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
          backgroundColor: Color.fromARGB(240, 3, 45, 69),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: getSignal(),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(
                                color: Color.fromARGB(255, 255, 255, 255))))),
                child: const Text("Signal Level"),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 380,
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(240, 3, 45, 69),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(255, 5, 5, 5),
                            offset: Offset(3.0, 6.0),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Running on \n \n $_signal_strength dBm',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 380,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(240, 3, 45, 69),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(3.0, 6.0),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Latitude \n $lat \n \n Longitude \n $long',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
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
              ElevatedButton.icon(
                  onPressed: getLocation,
                  icon: const Icon(Icons.add_location_rounded),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(171, 207, 17, 17),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100))),
                  label: const Text("Location")),
            ],
          ),
        ),
      ),
    );
  }
}
