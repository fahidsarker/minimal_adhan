import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/metadata.dart';
import 'package:minimal_adhan/prviders/dependencies/DuaDependencyProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/GlobalDependencyProvider.dart';
import 'package:minimal_adhan/prviders/locationProvider.dart';
import 'package:provider/provider.dart';
import 'Chooser.dart';

class AppLanguagePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalConfig = context.watch<GlobalDependencyProvider>();
    final duaDependency = context.read<DuaDependencyProvider>();
    final locationProvider = context.read<LocationProvider>();
    return choosingContainer(
      context: context,
      title: context.appLocale.language,
      titles: supportedLocales.map((e) => e.lang).toList(),
      subtitles: [],
      selected: (i) => globalConfig.locale == supportedLocales[i].languageCode,
      onChoosen: (i) => globalConfig.changeGlobalLocale(
        supportedLocales[i].languageCode,
        duaDependency,
        locationProvider,
      ),
      percentageUpto: 0.6,
    );
  }
}
