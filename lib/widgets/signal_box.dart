import 'package:flutter/material.dart';

class SignalBox extends StatelessWidget {
  final int signalLevel;

  const SignalBox({super.key, required this.signalLevel});

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
              const Icon(Icons.signal_cellular_alt,
                  color: Colors.white), // White icon color
              const SizedBox(height: 10),
              const Text(
                'Signal Level',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text color
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '$signalLevel dBm',
                style: const TextStyle(
                    fontSize: 14, color: Colors.white), // White text color
              ),
            ],
          ),
        ),
      ),
    );
  }
}
