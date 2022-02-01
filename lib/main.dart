import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:minimal_adhan/helpers/GPS_location_helper.dart';
import 'package:minimal_adhan/prviders/adhanPlayBackProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/DuaDependencyProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/GlobalDependencyProvider.dart';
import 'package:minimal_adhan/screens/Home/Home.dart';
import 'package:minimal_adhan/screens/adhan/widgets/onNotificaionScreen.dart';
import 'package:minimal_adhan/screens/locationFindingScreen.dart';
import 'package:minimal_adhan/screens/locationNotAvailableScreen.dart';
import 'package:minimal_adhan/screens/unknownErrorScreen.dart';
import 'package:minimal_adhan/screens/welcome/welcomeScreen.dart';
import 'package:minimal_adhan/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:upgrader/upgrader.dart';
import 'helpers/notification/notifiers.dart';

final onDarkCardColor = Colors.white.withOpacity(0.15);
final onLightCardColor = Colors.blueGrey.withOpacity(0.15);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await scheduleNotification(showNowIfPersistent: true);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final _globalDependency = GlobalDependencyProvider();
  final _adhanDependencyProvider = AdhanDependencyProvider();
  final _duaDependencyProvider = DuaDependencyProvider();
  await _globalDependency.init();
  await _duaDependencyProvider.init();
  await _adhanDependencyProvider.init();

  if (_adhanDependencyProvider.showPersistant) {
    // AndroidNotify.notify(silent: true);
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: _globalDependency),
      ChangeNotifierProvider.value(value: _adhanDependencyProvider),
      ChangeNotifierProvider.value(value: _duaDependencyProvider)
    ],
    child: MinimalAdhan(false),
  ));
}

class MinimalAdhan extends StatelessWidget {
  final bool fromNotification;

  MinimalAdhan(this.fromNotification);

  @override
  Widget build(BuildContext context) {
    final globalDependency = context.watch<GlobalDependencyProvider>();
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('ar', ''),
        const Locale('bn', ''),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale != null) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
        }
        return supportedLocales.first;
      },
      themeMode: globalDependency.themeMode,
      locale: Locale(globalDependency.locale),
      theme: getLightTheme(context, globalDependency),

      darkTheme: getDarkTheme(context, globalDependency),
      home: UpgradeAlert(
        child: fromNotification
            ? OnNotificationScreen()
            : globalDependency.welcomeScreenShown
            ? Home()
            : WelcomeScreen(true, 'Beta'),
        onUpdate: updateApp,
      ),
    );
  }

  bool updateApp() {
    if (Platform.isAndroid) {
      methodChannel.invokeMethod('openPlayStore');
      return true;
    } else {
      throw Exception("Invalid OS!");
    }
  }
}
