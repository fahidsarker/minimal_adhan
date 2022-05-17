import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/models/app_local.dart';

class LocaleBangla extends AppLocale{
  const LocaleBangla():super('bn');

  @override
  bool get duaElementsAvailable => true;

  @override
  String? get fontFamily => 'BalooDa2';

  @override
  String get languageName => 'বাংলা';


  @override
  TextTheme getTextTheme(BuildContext context){
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
      fontFamily: fontFamily,
    );
  }
}
