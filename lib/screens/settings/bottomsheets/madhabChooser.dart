import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:provider/provider.dart';
import 'Chooser.dart';

class MadhabChooser extends StatelessWidget {
  const MadhabChooser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final adhanDependency = context.watch<AdhanDependencyProvider>();
    final appLocale = AppLocalizations.of(context)!;

    return choosingContainer(
        context: context,
        title: appLocale.madhab,
        titles: [appLocale.hanafi_madhab, appLocale.shafi_madhab],
        subtitles: [appLocale.hanafi_asr_desc, appLocale.shafi_asr_desc],
        selected: (i) => adhanDependency.madhabIndex == i,
        onChoosen: adhanDependency.changeMadhab,
        percentageUpto: 0.4
    );
  }
}
