import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/initDependency.dart';
import 'package:minimal_adhan/localizations/locales.dart';
import 'package:minimal_adhan/prviders/dependencies/GlobalDependencyProvider.dart';
import 'package:minimal_adhan/prviders/locationProvider.dart';
import 'package:minimal_adhan/screens/dynamic_display/dynamic_display.dart';
import 'package:minimal_adhan/screens/welcome/welcomeScreen.dart';
import 'package:minimal_adhan/theme.dart';
import 'package:provider/provider.dart';

final onDarkCardColor = Colors.white.withOpacity(0.15);
final onLightCardColor = Colors.blueGrey.withOpacity(0.15);

void main() {
  initializeAppWith(child: const Azan()).then((value) => runApp(value));
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
      theme: getLightTheme(context, globalDependency),
      darkTheme: getDarkTheme(context, globalDependency),
      home: globalDependency.welcomeScreenShown
          ? DynamicDisplay(locationProvider)
          : const WelcomeScreen(showWarning: false, build: 'Stable'),
    );
  }
}
