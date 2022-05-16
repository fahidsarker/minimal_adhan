import 'package:minimal_adhan/extensions.dart';
import 'package:flutter/material.dart';
import 'package:minimal_adhan/metadata.dart';

import '../helpers/locale_helper.dart';

class AppLocale extends Locale {
  final String lang;
  final bool duaAvailable;
  final String? fontFamily;

  static AppLocale of(String code) {
    return supportedLocales
        .firstWhere((element) => element.languageCode == code);
  }

  TextTheme getTextTheme(BuildContext context) {
    return getCustomTextTheme(context, this);
  }

  const AppLocale(String code, this.lang,
      {required this.duaAvailable,
      this.fontFamily}) : super(code);
}
