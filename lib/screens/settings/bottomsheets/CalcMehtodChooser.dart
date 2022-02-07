import 'package:flutter/material.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/helpers/adhan_dependencies.dart';
import 'package:provider/provider.dart';
import 'package:minimal_adhan/extensions.dart';

import 'Chooser.dart';
class CalcMethodChooser extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final adhanDependency = context.watch<AdhanDependencyProvider>();
    final appLocale = context.appLocale;
    return choosingContainer(
      context: context,
      title: appLocale.calc_method,
      titles: adhanCalculationMethodNames,
      subtitles: adhanCalculationMethodDescs,
      selected: (i) => adhanDependency.calMethodIndex == i,
      onChoosen: adhanDependency.changeCalMethod,
      percentageUpto: 0.9
    );
  }
}
