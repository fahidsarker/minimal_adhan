import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:minimal_adhan/helpers/adhan_dependencies.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:provider/provider.dart';
import 'Chooser.dart';

class HighLatRuleChooser extends StatelessWidget {
  const HighLatRuleChooser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final adhanDependency = context.watch<AdhanDependencyProvider>();
    final appLocale = AppLocalizations.of(context)!;
    return choosingContainer(
        context: context,
        title: appLocale.high_lat_rule,
        titles: highLatRulesNames,
        subtitles: highLatRulesDescs,
        selected: (i) => adhanDependency.highLatRuleIndex == i,
        onChoosen: adhanDependency.changeHighLatRuleIndex,
        percentageUpto: 0.5
    );
  }
}
