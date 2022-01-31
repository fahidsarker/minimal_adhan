import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:minimal_adhan/localization/supportedLangs.dart';
import 'package:minimal_adhan/prviders/adhanPlayBackProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/DuaDependencyProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/GlobalDependencyProvider.dart';
import 'package:minimal_adhan/screens/Home/Home.dart';
import 'package:minimal_adhan/screens/HomeScreen.dart';
import 'package:minimal_adhan/screens/adhan/widgets/onNotificaionScreen.dart';
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
  await scheduleNotification();

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
    final darkBack = Color.fromRGBO(29, 51, 64, 1);
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
      /*ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            textTheme: Theme.of(context).textTheme),
        cardColor: Colors.white,
        brightness: Brightness.light,
        accentColor: Colors.blueGrey,
        fontFamily: getFont(globalDependency.locale),
        textTheme: getTextTheme(context, globalDependency.locale),
      ),*/
      darkTheme: getDarkTheme(context, globalDependency),
      /*ThemeData(
          bottomNavigationBarTheme:
              BottomNavigationBarThemeData(backgroundColor: darkBack),
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: darkBack),
          appBarTheme: AppBarTheme(
            brightness: Brightness.dark,
            backgroundColor: darkBack,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          fontFamily: getFont(globalDependency.locale),
          textTheme: getTextTheme(context, globalDependency.locale).apply(
            bodyColor: Colors.white,
            displayColor: Colors.white70,
          ),
          canvasColor: darkBack,
          cardColor: darkBack,
          dialogTheme: DialogTheme(backgroundColor: darkBack),
          scaffoldBackgroundColor: darkBack,
          brightness: Brightness.dark,
          backgroundColor: darkBack,
          accentColor: Colors.white),*/
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
