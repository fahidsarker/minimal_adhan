import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/models/app_local.dart';

class LocaleEnglish extends AppLocale{
  const LocaleEnglish():super('en');

  @override
  bool get duaElementsAvailable => true;

  @override
  String? get fontFamily => null;

  @override
  TextTheme getTextTheme(BuildContext context) => context.textTheme;

  @override
  String get languageName => 'English';

}
