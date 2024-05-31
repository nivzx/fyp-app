import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/api_service.dart';

class GoogleMapWidget extends StatefulWidget {
  final double initialLat;
  final double initialLong;

  const GoogleMapWidget({
    Key? key,
    required this.initialLat,
    required this.initialLong,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  Set<Marker> _mapMarkers = {};

  @override
  void initState() {
    super.initState();
    // Call the method to fetch data and update markers every 5 minutes
    _fetchDataAndSetMarkers();
    Timer.periodic(const Duration(seconds: 30), (timer) {
      _fetchDataAndSetMarkers();
    });
  }

  Future<void> _fetchDataAndSetMarkers() async {
    final ByteData markerIconData =
        await rootBundle.load('assets/level_marker.png');
    final Uint8List markerIconBytes = markerIconData.buffer.asUint8List();
    final BitmapDescriptor customIcon =
        BitmapDescriptor.fromBytes(markerIconBytes);

    List<dynamic> data = await ApiService.getHighLocations();

    // List<dynamic> data = await DummyService.getDummyLocations();

    Set<Marker> markers = data.map((item) {
      final location = item['location'].toString().split('_');
      return Marker(
        markerId: MarkerId(item['location']),
        position: LatLng(double.parse(location[0]), double.parse(location[1])),
        infoWindow: InfoWindow(
          title: 'Level: ${item['level']}',
        ),
        icon: customIcon, // Use custom marker icon
      );
    }).toSet();

    setState(() {
      _mapMarkers = markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(widget.initialLat, widget.initialLong),
      zoom: 15,
    );

    return GoogleMap(
      onMapCreated: (controller) {},
      initialCameraPosition: initialCameraPosition,
      markers: _mapMarkers,
    );
  }
}
