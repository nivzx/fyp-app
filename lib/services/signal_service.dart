import 'package:flutter/services.dart';
import 'package:gsm_info/gsm_info.dart';

import 'dart:math';

class SignalService {
  static Future<int> getSignalStrength(bool usePredefinedSignalStrength) async {
    try {
      if (usePredefinedSignalStrength) {
        return -20;
      } else {
        int signalStrength = await GsmInfo.gsmSignalDbM;
        return signalStrength;
      }
    } on PlatformException {
      return -999;
    }
  }

  static Future<double> getRandomStrength() async {
    return Random().nextDouble();
  }
}
