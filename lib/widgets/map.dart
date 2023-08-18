import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
import 'package:g/services/dummy_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatefulWidget {
  final double initialLat;
  final double initialLong;

  const GoogleMapWidget({
    Key? key,
    required this.initialLat,
    required this.initialLong,
  }) : super(key: key);

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  GoogleMapController? _controller;
  Set<Marker> _mapMarkers = {};

  @override
  void initState() {
    super.initState();
    // Call the method to fetch data and update markers every 5 minutes
    _fetchDataAndSetMarkers();
    Timer.periodic(Duration(minutes: 5), (timer) {
      _fetchDataAndSetMarkers();
    });
  }

  Future<BitmapDescriptor> _getCustomMarkerIcon() async {
    final ByteData markerIconData =
        await rootBundle.load('assets/level_marker.png');
    final Uint8List markerIconBytes = markerIconData.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(markerIconBytes);
  }

  Future<void> _fetchDataAndSetMarkers() async {
    final ByteData markerIconData =
        await rootBundle.load('assets/level_marker.png');
    final Uint8List markerIconBytes = markerIconData.buffer.asUint8List();
    final BitmapDescriptor customIcon =
        BitmapDescriptor.fromBytes(markerIconBytes);

    // List<dynamic> data = await ApiService.getHighLocations();

    List<dynamic> data = await DummyService.getDummyLocations();

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
      onMapCreated: (controller) {
        _controller = controller;
      },
      initialCameraPosition: initialCameraPosition,
      markers: _mapMarkers,
    );
  }
}
