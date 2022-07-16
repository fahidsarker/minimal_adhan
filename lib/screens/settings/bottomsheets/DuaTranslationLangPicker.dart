import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/localizations/locales.dart';
import 'package:minimal_adhan/models/app_local.dart';
import 'package:minimal_adhan/prviders/dependencies/DuaDependencyProvider.dart';
import 'package:minimal_adhan/screens/settings/bottomsheets/Chooser.dart';
import 'package:provider/provider.dart';


class DuaTranslationLangPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appLocale = context.appLocale;
    final duaDependency = context.watch<DuaDependencyProvider>();
    final langs = [
      appLocale.primary_language,
      ...supportedLocales
          .where((element) => element.duaElementsAvailable)
          .map((e) => e.languageName)
          .toList()
    ];
    return choosingContainer(
        context: context,
        title: appLocale.translation_lang,
        titles: langs,
        subtitles: [],
        selected: (i) => i > 0
            ? (duaDependency.sameAsPrimaryLang
                ? !duaDependency.sameAsPrimaryLang
                : duaDependency.translationLang ==
                    supportedLocales[i].languageCode)
            : duaDependency.sameAsPrimaryLang,
        onChoosen: (i) => i == 0
            ? duaDependency.setDuaLangToPrimary()
            : duaDependency.changeTranslationLang(
                AppLocale.byName(langs[i]).languageCode,
              ),
        percentageUpto: 0.6);
  }
}
