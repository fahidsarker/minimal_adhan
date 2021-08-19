import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimal_adhan/helpers/sharedprefKeys.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/DuaDependencyProvider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GlobalDependencyProvider with ChangeNotifier {
  late ThemeMode _themeMode;
  late int themeModeIndex;
  late String locale;
  late String appName;
  late String version;
  late String buildNumber;
  late bool _welcomeScreenShown;

  GlobalDependencyProvider();

  Future<void> init() async {
    final preference = await SharedPreferences.getInstance();
    locale = preference.getString(KEY_ADHAN_CURRENT_LOCALIZATION) ??
        DEFAULT_ADHAN_CURRENT_LOCALIZATION;

    _themeMode = getThemeMode(
        preference.getInt(KEY_ADHAN_THEME_MODE) ?? DEFAULT_ADHAN_THEME_MODE);
    _welcomeScreenShown = preference.getBool(KEY_WELCOME_SCREEN_SHOWN) ?? false;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appName = packageInfo.appName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }

  bool get welcomeScreenShown {
    return _welcomeScreenShown;
  }

  void welcomeComplete() async {
    final preference = await SharedPreferences.getInstance();
    final success = await preference.setBool(KEY_WELCOME_SCREEN_SHOWN, true);
    if (success) {
      _welcomeScreenShown = true;
      notifyListeners();
    }
  }

  ThemeMode getThemeMode(int theme) {
    themeModeIndex = theme;
    if (theme == ADHAN_THEME_MODE_LIGHT) {
      return ThemeMode.light;
    } else if (theme == ADHAN_THEME_MODE_DARK) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  String getThemeModeText(AppLocalizations appLocale) {
    if (_themeMode == ThemeMode.light) {
      return appLocale.always_light;
    } else if (_themeMode == ThemeMode.dark) {
      return appLocale.always_dark;
    } else {
      return appLocale.follow_system;
    }
  }

  void changeGlobalLocale(
      String newLocale,
      DuaDependencyProvider dependencyProvider,
      AdhanDependencyProvider adhanDependencyProvider) async {
    final pref = await SharedPreferences.getInstance();
    final lastLocale = pref.getString(KEY_ADHAN_CURRENT_LOCALIZATION) ??
        DEFAULT_ADHAN_CURRENT_LOCALIZATION;
    final duaSameAsPrimary =
        pref.getBool(KEY_DUA_SAME_AS_PRIMARY) ?? DEFAULT_DUA_SAME_AS_PRIMARY;

    if (lastLocale != newLocale) {
      final result =
          await pref.setString(KEY_ADHAN_CURRENT_LOCALIZATION, newLocale);
      if (duaSameAsPrimary) {
        dependencyProvider.setDuaLangToPrimary();
      }
      if (result) {
        locale = newLocale;
        if (welcomeScreenShown) {
          adhanDependencyProvider.updateLocationWithGPS(background: true);
        }

        notifyListeners();
      }
    }
  }

  void updateThemeMode(int newMode) async {
    final pref = await SharedPreferences.getInstance();
    final success = await pref.setInt(KEY_ADHAN_THEME_MODE, newMode);
    if (success) {
      _themeMode = getThemeMode(newMode);
      notifyListeners();
    }
  }

  ThemeMode get themeMode {
    return _themeMode;
  }
}
