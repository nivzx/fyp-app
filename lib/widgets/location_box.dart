import 'package:flutter/material.dart';

class LocationBox extends StatelessWidget {
  final double lat;
  final double long;

  const LocationBox({required this.lat, required this.long});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380,
      height: 180,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(240, 3, 45, 69),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(3.0, 6.0),
                blurRadius: 10.0,
              ),
            ],
          ),
          child: Center(
            child: Text(
              'Latitude \n $lat \n \n Longitude \n $long',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
