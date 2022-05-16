import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import '../models/app_local.dart';

const localeLanguageCodeEnglish = 'en';
const localeLanguageCodeArabic = 'ar';
const localeLanguageCodeBangla = 'bn';

const supportedLocales = [
  AppLocale('en', 'English', duaAvailable: true),
  AppLocale(
    'ar',
    '(Beta) عربى',
    duaAvailable: false,
    fontFamily: 'lateef',
  ),
  AppLocale(
    'bn',
    'বাংলা (Beta)',
    duaAvailable: true,
    fontFamily: "BalooDa2",
  ),
];

TextTheme getCustomTextTheme(BuildContext context, AppLocale locale) {
  final langCode = locale.languageCode;
  switch (langCode) {
    case localeLanguageCodeArabic:
      return context.textTheme
          .copyWith(
            headline1: context.textTheme.headline1?.copyWith(height: 1.0),
            headline5: context.textTheme.headline5?.copyWith(
              height: 1.0,
            ),
            headline6: context.textTheme.headline6?.copyWith(
              height: 1.5,
            ),
          )
          .apply(fontFamily: locale.fontFamily);

    case localeLanguageCodeBangla:
      return context.textTheme
          .copyWith(
            headline1: context.textTheme.headline1?.copyWith(height: 1.0),
            headline3: context.textTheme.headline3?.copyWith(height: 1.5),
            headline5: context.textTheme.headline5?.copyWith(
              height: 1.5,
            ),
            headline6: context.textTheme.headline6?.copyWith(
              height: 1,
            ),
          )
          .apply(
            fontFamily: locale.fontFamily,
          );

      default:
        return context.textTheme;
  }
}
