import 'package:geolocator/geolocator.dart';
import 'dart:math';

class LocationService {
  static Future<Position> getCurrentPosition(bool usePredefinedLocation) async {
    if (usePredefinedLocation) {
      return Position(
          latitude: 6.081,
          longitude: 80.121,
          accuracy: 0.0, // Placeholder value for accuracy
          altitude: 0.0, // Placeholder value for altitude
          heading: 0.0, // Placeholder value for heading
          speed: 0.0, // Placeholder value for speed
          speedAccuracy: 0.0, // Placeholder value for speed accuracy
          timestamp: DateTime.now());
    } else {
      return Geolocator.getCurrentPosition();
    }
  }

  //Get random location for testing
  static Future<Position> getRandomPosition() async {
    double randomLat =
        Random().nextDouble() * 180 - 90; // Random latitude between -90 and 90
    double randomLong = Random().nextDouble() * 360 -
        180; // Random longitude between -180 and 180

    return Position(
        latitude: randomLat,
        longitude: randomLong,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        floor: 0,
        isMocked: false);
  }
}
