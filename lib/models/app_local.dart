import 'package:flutter/material.dart';
import 'package:minimal_adhan/localizations/locales.dart';

abstract class AppLocale extends Locale {
  abstract final String languageName;
  abstract final bool duaElementsAvailable;
  abstract final String? fontFamily;

  static AppLocale of(String code) {
    return supportedLocales
        .firstWhere((element) => element.languageCode == code);
  }

  static AppLocale byName(String name) {
    return supportedLocales
        .firstWhere((element) => element.languageName == name);
  }

  TextTheme getTextTheme(BuildContext context);


  const AppLocale(String code) : super(code);
}
