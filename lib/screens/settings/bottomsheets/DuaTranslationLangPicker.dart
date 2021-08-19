import 'package:flutter/material.dart';
import 'package:minimal_adhan/localization/supportedLangs.dart';
import 'package:minimal_adhan/prviders/dependencies/DuaDependencyProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'Chooser.dart';

class DuaTranslationLangPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context)!;
    final duaDependency = context.watch<DuaDependencyProvider>();
    print(duaDependency.translationLang);
    return choosingContainer(
        context: context,
        title: appLocale.translation_lang,
        titles: [appLocale.language, ...supportedAppLangs.map((e) => e['lang'] as String).toList()],
        subtitles: [],
        selected: (i) =>
            i > 0 ? (duaDependency.sameAsPrimaryLang
            ? false
            : duaDependency.translationLang == supportedAppLangs[i - 1]['code'])
            : duaDependency.sameAsPrimaryLang,
        onChoosen: (i) => i == 0 ? duaDependency.setDuaLangToPrimary() : duaDependency.changeTranslationLang(supportedAppLangs[i-1]['code'] as String),
        percentageUpto: 0.6
    );
  }
}
