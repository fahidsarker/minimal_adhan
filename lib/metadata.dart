import 'dart:ui';

const DB_VERSION = 4;
const TOTAL_INSPIRATIONS = 3;

class AppLocale extends Locale {
  final String lang;

  const AppLocale(String code, this.lang) : super(code);

}

const supportedAppLangs =  [
  AppLocale('en', 'English'),
  //AppLocale('ar', '(Beta) عربى'),
  //AppLocale('bn', 'বাংলা (Beta)')
];

