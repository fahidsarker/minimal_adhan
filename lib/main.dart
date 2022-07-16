import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/helpers/preferences.dart';
import 'package:minimal_adhan/localizations/locales.dart';
import 'package:minimal_adhan/models/preference.dart';
import 'package:minimal_adhan/prviders/app_init_provider.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/GlobalDependencyProvider.dart';
import 'package:minimal_adhan/prviders/locationProvider.dart';
import 'package:minimal_adhan/screens/dynamic_display/dynamic_display.dart';
import 'package:minimal_adhan/screens/welcome/welcomeScreen.dart';
import 'package:minimal_adhan/theme.dart';
import 'package:provider/provider.dart';

final onDarkCardColor = Colors.white.withOpacity(0.15);
final onLightCardColor = Colors.blueGrey.withOpacity(0.15);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initPreferences();

  runApp(ChangeNotifierProvider(
      create: (_) => AppInitProvider.create(), child: const AzanApp()));
}

class AzanApp extends StatelessWidget {
  const AzanApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appInitProvider = Provider.of<AppInitProvider>(context, listen: true);
    if (appInitProvider.initComplete) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
              value: GlobalDependencyProvider.getInstance()),
          ChangeNotifierProvider.value(value: LocationProvider.getInstance()),
          ChangeNotifierProvider(create: (_) => AdhanDependencyProvider()),
        ],
        child: const Azan(),
      );
    }

    return MaterialApp(
      themeMode:
          GlobalDependencyProvider.getThemeMode(sharedPrefAdhanThemeMode.value),
      theme: getLightTheme(context),
      darkTheme: getDarkTheme(context),
      home: Scaffold(
          body: Center(
        child: Image.asset(
          'assets/logo.png',
          width: 240,
        ),
      )),
    );
  }
}

class Azan extends StatelessWidget {
  const Azan();

  @override
  Widget build(BuildContext context) {
    final globalDependency = context.watch<GlobalDependencyProvider>();
    final locationProvider = context.read<LocationProvider>();

    return MaterialApp(
      localizationsDelegates: appLocaleDelegates,
      supportedLocales: supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale != null) {
          for (final supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
        }
        return supportedLocales.first;
      },
      themeMode: globalDependency.themeMode,
      locale: Locale(globalDependency.locale),
      theme: getLightTheme(context),
      darkTheme: getDarkTheme(context),
      home: globalDependency.welcomeScreenShown
          ? DynamicDisplay(locationProvider)
          : const WelcomeScreen(showWarning: false, build: 'Stable'),
    );
  }
}
