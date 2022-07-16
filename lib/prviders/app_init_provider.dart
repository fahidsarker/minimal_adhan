import 'package:flutter/material.dart';
import 'package:minimal_adhan/prviders/dependencies/GlobalDependencyProvider.dart';
import 'package:minimal_adhan/prviders/locationProvider.dart';

import '../helpers/notification/notifiers.dart';
import '../platform_dependents/android_flutter_background_service.dart';

class AppInitProvider with ChangeNotifier {

  bool _initComplete = false;

  bool get initComplete => _initComplete;


  AppInitProvider._();

  factory AppInitProvider.create() => AppInitProvider._().._initFunction();


  void _setInitComplete(bool value) {
    _initComplete = value;
    notifyListeners();
  }


  void _initFunction() async{


    // todo app init here
    await scheduleNotification(showNowIfPersistent: true);
    await initFlutterAndroidBackgroundService();
    await GlobalDependencyProvider.getInstance().init();
    await LocationProvider.getInstance().init();

    _setInitComplete(true);

  }

}

