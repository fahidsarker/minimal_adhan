import 'dart:ui';

const DB_VERSION = 4;
const TOTAL_INSPIRATIONS = 3;

class AppLocale extends Locale {
  final String lang;
  final bool duaAvailable;
  final String? fontFamily;

  static AppLocale of(String code) {
    return supportedAppLangs
        .firstWhere((element) => element.languageCode == code);
  }

  const AppLocale(String code, this.lang, {required this.duaAvailable, this.fontFamily}) : super(code);

}

const supportedAppLangs =  [
  AppLocale('en', 'English', duaAvailable: true),
  //AppLocale('ar', '(Beta) عربى'),
  AppLocale('bn', 'বাংলা (Beta)', duaAvailable: false, fontFamily: "BalooDa2")
];

