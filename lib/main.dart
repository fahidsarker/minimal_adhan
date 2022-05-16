import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/helpers/locale_helper.dart';
import 'package:minimal_adhan/initDependency.dart';
import 'package:minimal_adhan/platform_dependents/method_channel_helper.dart';
import 'package:minimal_adhan/prviders/dependencies/GlobalDependencyProvider.dart';
import 'package:minimal_adhan/prviders/locationProvider.dart';
import 'package:minimal_adhan/screens/dynamic_display/dynamic_display.dart';
import 'package:minimal_adhan/screens/welcome/welcomeScreen.dart';
import 'package:minimal_adhan/theme.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';

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
      home: UpgradeAlert(
        child: globalDependency.welcomeScreenShown
            ? DynamicDisplay(locationProvider)
            : const WelcomeScreen(showWarning: true, build: 'Beta'),
        onUpdate: () {
          PlatformCall.openAppStore();
          return true;
        },
      ),
    );
  }
}
