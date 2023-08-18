import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatefulWidget {
  final double initialLat;
  final double initialLong;

  const GoogleMapWidget(
      {super.key, required this.initialLat, required this.initialLong});

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  GoogleMapController? _controller;

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
      // markers: {
      //   Marker(
      //     markerId: MarkerId('your_marker_id'),
      //     position: LatLng(widget.initialLat, widget.initialLong),
      //     infoWindow: InfoWindow(title: 'Marker Title'),
      //   ),
      // },
    );
  }
}
