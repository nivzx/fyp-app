import 'package:flutter/material.dart';

class StaticMap extends StatelessWidget {
  final double latitude;
  final double longitude;
  final double signalValue;

  const StaticMap({
    required this.latitude,
    required this.longitude,
    required this.signalValue,
  });

  @override
  Widget build(BuildContext context) {
    String markerColor;
    if (signalValue > -50) {
      markerColor = 'red';
    } else if (signalValue > -90) {
      markerColor = 'yellow';
    } else {
      markerColor = 'green';
    }

    final mapUrl =
        'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=15&size=400x300&maptype=roadmap&markers=color:$markerColor%7C$latitude,$longitude&key=AIzaSyDpTPYh7tmb_ootQRJ60y4JGIZCehtaARw';

    return Image.network(mapUrl);
  }
}
