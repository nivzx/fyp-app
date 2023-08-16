import 'package:flutter/material.dart';

class LocationBox extends StatelessWidget {
  final double lat;
  final double long;

  const LocationBox({required this.lat, required this.long});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190, // Reduced width for single row layout
      height: 150,
      child: Card(
        elevation: 5.0,
        color:
            const Color.fromARGB(240, 3, 45, 69), // Set background color to red
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on,
                  color: Colors.white), // White icon color
              const SizedBox(height: 10),
              const Text(
                'Location',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text color
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      'Latitude: ${lat.toStringAsFixed(4)}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white), // White text color
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      'Longitude: ${long.toStringAsFixed(4)}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white), // White text color
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
