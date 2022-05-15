import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/metadata.dart';



TextTheme getTextTheme(BuildContext context, String locale) {
  if (locale == 'en') {
    return context.textTheme;
  } else if (locale == 'bn') {
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
        .apply(fontFamily: AppLocale.of(locale).fontFamily);
  } else if (locale == 'ar') {
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
        .apply(fontFamily: 'Lateef');
  } else {
    throw Exception('Locale Not supported!');
  }
}



/*
Object getSupportedLangInfo(String locale, String key) {
  final langs =
      supportedAppLangs.firstWhere((element) => element.code == locale);
  return langs[key] as Object;
}*/
