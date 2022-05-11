import 'dart:io';

import 'package:optimize_battery/optimize_battery.dart';

class PlatformPreferences {
  static Future<bool> get isIgnoringBatteryOptimizations async {
    if (Platform.isAndroid) {
      return OptimizeBattery.isIgnoringBatteryOptimizations();
    } else {
      return true;
    }
  }

  PlatformPreferences._();
}
