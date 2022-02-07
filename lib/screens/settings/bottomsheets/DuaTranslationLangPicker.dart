import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/metadata.dart';
import 'package:minimal_adhan/prviders/dependencies/DuaDependencyProvider.dart';
import 'package:minimal_adhan/screens/settings/bottomsheets/Chooser.dart';
import 'package:provider/provider.dart';

class DuaTranslationLangPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appLocale = context.appLocale;
    final duaDependency = context.watch<DuaDependencyProvider>();

    return choosingContainer(
        context: context,
        title: appLocale.translation_lang,
        titles: [
          appLocale.language,
          ...supportedAppLangs.map((e) => e.lang).toList()
        ],
        subtitles: [],
        selected: (i) => i > 0
            ? (duaDependency.sameAsPrimaryLang
                ? !duaDependency.sameAsPrimaryLang
                : duaDependency.translationLang ==
                    supportedAppLangs[i - 1].languageCode)
            : duaDependency.sameAsPrimaryLang,
        onChoosen: (i) => i == 0
            ? duaDependency.setDuaLangToPrimary()
            : duaDependency
                .changeTranslationLang(supportedAppLangs[i - 1].languageCode),
        percentageUpto: 0.6);
  }
}
