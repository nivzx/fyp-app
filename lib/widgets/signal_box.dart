import 'package:flutter/material.dart';

class SignalBox extends StatelessWidget {
  final double signalLevel;

  const SignalBox({required this.signalLevel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380,
      height: 120,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(240, 3, 45, 69),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 5, 5, 5),
                offset: Offset(3.0, 6.0),
                blurRadius: 10.0,
              ),
            ],
          ),
          child: Center(
            child: Text(
              'Running on \n \n $signalLevel dBm',
              style: TextStyle(
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
