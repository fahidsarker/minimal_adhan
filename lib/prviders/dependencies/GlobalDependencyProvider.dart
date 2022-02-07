import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:minimal_adhan/helpers/preferences.dart';
import 'package:minimal_adhan/prviders/dependencies/DuaDependencyProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/dependency_provider.dart';
import 'package:minimal_adhan/prviders/locationProvider.dart';
import 'package:optimize_battery/optimize_battery.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalDependencyProvider extends DependencyProvider {
  GlobalDependencyProvider();

  static late SharedPreferences _preferences;
  late PackageInfo packageInfo;
  late bool batteryOptimizeDisabled;

  SharedPreferences get preference => _preferences;

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
    _preferences = await SharedPreferences.getInstance();
    packageInfo = await PackageInfo.fromPlatform();
    batteryOptimizeDisabled =
        await OptimizeBattery.isIgnoringBatteryOptimizations();
  }

  bool get needToShowDiableBatteryOptimizeDialog {
    return !neverAskToDisableBatteryOptimizer && !batteryOptimizeDisabled;
  }

  Future disableBatteryOptimization() async {
    await OptimizeBattery.stopOptimizingBatteryUsage();
    batteryOptimizeDisabled =
        await OptimizeBattery.isIgnoringBatteryOptimizations();
    notifyListeners();
  }

  void setNeverAskDisableBatteryOptimize() => updateDataWithPreference(
      sharedPrefAdhanNeverAskAgainForBatteryOptimization, true);

  void welcomeComplete() =>
      updateDataWithPreference(sharedPrefWelcomeShown, true);

  ThemeMode getThemeMode(int theme) {
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
