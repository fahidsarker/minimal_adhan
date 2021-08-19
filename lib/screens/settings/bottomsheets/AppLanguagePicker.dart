import 'package:flutter/material.dart';
import 'package:minimal_adhan/localization/supportedLangs.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/DuaDependencyProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/GlobalDependencyProvider.dart';
import 'package:provider/provider.dart';
import 'package:minimal_adhan/extensions.dart';

import 'Chooser.dart';

class AppLanguagePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalConfig = context.watch<GlobalDependencyProvider>();
    final duaDependency = context.read<DuaDependencyProvider>();
    final adhanDependency = context.read<AdhanDependencyProvider>();
    return choosingContainer(
        context: context,
        title: context.appLocale.language,
        titles: supportedAppLangs.map((e) => e['lang'] as String).toList(),
        subtitles: [],
        selected: (i) => globalConfig.locale == supportedAppLangs[i]['code'],
        onChoosen: (i) => globalConfig.changeGlobalLocale(supportedAppLangs[i]['code'] as String, duaDependency,adhanDependency),
        percentageUpto: 0.6
    );
  }
}
