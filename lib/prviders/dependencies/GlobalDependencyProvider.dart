import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:minimal_adhan/helpers/preferences.dart';
import 'package:minimal_adhan/prviders/dependencies/DuaDependencyProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/dependency_provider.dart';
import 'package:minimal_adhan/prviders/locationProvider.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../platform_dependents/preferences.dart';

class GlobalDependencyProvider extends DependencyProvider {
  GlobalDependencyProvider._();

  static GlobalDependencyProvider? _instance;

  factory GlobalDependencyProvider.getInstance() {
    _instance ??= GlobalDependencyProvider._();
    return _instance!;
  }

  late PackageInfo packageInfo;

  bool get isIgnoringBatteryOptimizations =>
      sharedPrefIsIgnoringBatteryOptimizations.value;

  int get themeModeIndex => sharedPrefAdhanThemeMode.value;

  String get locale => sharedPrefAdhanCurrentLocalization.value;

  ThemeMode get themeMode => getThemeMode(themeModeIndex);

  bool get welcomeScreenShown => sharedPrefWelcomeShown.value;

  String get appName => packageInfo.appName;

  String get version => packageInfo.version;

  String get buildNumber => packageInfo.buildNumber;

  bool get neverAskToDisableBatteryOptimizer =>
      sharedPrefAdhanNeverAskAgainForBatteryOptimization.value;

  Future<void> init() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

/*  Future disableBatteryOptimization() async {
    try{
      await FlutterForegroundTask.startService(notificationTitle: 'Adhan Foreground', notificationText: 'Helps keep adhan alive');
      batteryOptimizeDisabled = await PlatformPreferences.isIgnoringBatteryOptimizations;
      notifyListeners();
    }catch(e){
      if(kDebugMode){
        print(e);
      }
    }
  }*/

  bool get needToShowDiableBatteryOptimizeDialog {
    if (isIgnoringBatteryOptimizations) {
      return false;
    }
    if (neverAskToDisableBatteryOptimizer) {
      return false;
    }
    return true;
  }

  Future<void> ignoreBatteryOptimization({required bool status}) async {
    try {
      if (status) {
        await FlutterForegroundTask.startService(
          notificationTitle: 'Adhan Active',
          notificationText:
              'Helps keep adhan alive in background for notifications.',
        );
      } else {
        await FlutterForegroundTask.stopService();
      }

      sharedPrefIsIgnoringBatteryOptimizations.updateValue(status);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void setNeverAskDisableBatteryOptimize() => updateDataWithPreference(
        sharedPrefAdhanNeverAskAgainForBatteryOptimization,
        true,
      );

  void welcomeComplete() =>
      updateDataWithPreference(sharedPrefWelcomeShown, true);

  static ThemeMode getThemeMode(int theme) {
    if (theme == ADHAN_THEME_MODE_LIGHT) {
      return ThemeMode.light;
    } else if (theme == ADHAN_THEME_MODE_DARK) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  String getThemeModeText(AppLocalizations appLocale) {
    if (themeMode == ThemeMode.light) {
      return appLocale.always_light;
    } else if (themeMode == ThemeMode.dark) {
      return appLocale.always_dark;
    } else {
      return appLocale.follow_system;
    }
  }

  void changeGlobalLocale(
    String newLocale,
    DuaDependencyProvider dependencyProvider,
    LocationProvider locationProvider,
  ) {
    final lastLocale = sharedPrefAdhanCurrentLocalization.value;
    final duaSameAsPrimary = sharedPrefDuaSameAsPrimary.value;

    if (lastLocale != newLocale) {
      updateDataWithPreference(sharedPrefAdhanCurrentLocalization, newLocale);
      if (duaSameAsPrimary) {
        dependencyProvider.setDuaLangToPrimary();
      }

      if (welcomeScreenShown) {
        locationProvider.updateLocationWithGPS(background: true);
      }
      notifyListeners();
    }
  }

  void updateThemeMode(int newMode) =>
      updateDataWithPreference(sharedPrefAdhanThemeMode, newMode);
}
