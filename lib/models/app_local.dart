import 'package:minimal_adhan/extensions.dart';
import 'package:flutter/material.dart';
import 'package:minimal_adhan/metadata.dart';

class AppLocale extends Locale {
  final String lang;
  final bool duaAvailable;
  final String? fontFamily;
  final TextTheme Function(BuildContext context)? _generateTextTheme;

  static AppLocale of(String code) {
    return supportedLocales
        .firstWhere((element) => element.languageCode == code);
  }

  TextTheme getTextTheme(BuildContext context) {
    return _generateTextTheme?.call(context) ?? context.textTheme;
  }

  const AppLocale(String code, this.lang,
      {required this.duaAvailable,
      this.fontFamily,
      TextTheme Function(BuildContext context)? generateTextTheme})
      : _generateTextTheme = generateTextTheme,
        super(code);
}
