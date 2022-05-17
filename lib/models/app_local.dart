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

  TextTheme getTextTheme(BuildContext context);

  const AppLocale(String code) : super(code);
}
