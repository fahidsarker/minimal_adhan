import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:minimal_adhan/helpers/SQLHelper.dart';
import 'package:minimal_adhan/helpers/notification/notifiers.dart';
import 'package:minimal_adhan/models/preference.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/GlobalDependencyProvider.dart';
import 'package:minimal_adhan/prviders/locationProvider.dart';
import 'package:provider/provider.dart';

Future<Widget> initializeAppWith ({required Widget child}) async{
  WidgetsFlutterBinding.ensureInitialized();
  await initPreferences();
  await scheduleNotification(showNowIfPersistent: true);

  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  final _globalDependency = GlobalDependencyProvider();
  await _globalDependency.init();
  final _locationProvider = LocationProvider();
  await _locationProvider.init();

  return MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: _globalDependency), //required for entire app
      ChangeNotifierProvider.value(value: _locationProvider), //required in entire app
      ChangeNotifierProvider(create: (_)=> AdhanDependencyProvider()) //required for homescreen
    ],
    child: child,
  );
}
