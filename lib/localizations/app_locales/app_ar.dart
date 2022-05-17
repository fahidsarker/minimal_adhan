import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/models/app_local.dart';

class LocaleArabic extends AppLocale{
  const LocaleArabic(): super('ar');

  @override
  String get languageName => '(Beta) عربى';

  @override
  bool get duaElementsAvailable => false;

  @override
  String? get fontFamily => 'lateef';

  @override
  TextTheme getTextTheme(BuildContext context){
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
        .apply(
      fontFamily: fontFamily,
    );
  }

}
