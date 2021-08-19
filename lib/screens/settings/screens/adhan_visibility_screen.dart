import 'package:flutter/material.dart';
import 'package:minimal_adhan/prviders/adhanProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/screens/settings/widgets/SettingsTile.dart';
import 'package:provider/provider.dart';
import 'package:minimal_adhan/extensions.dart';

class AdhanVisibilityScreen extends StatelessWidget {
  const AdhanVisibilityScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final appLocale = context.appLocale;
    final adhanDependency = context.watch<AdhanDependencyProvider>();

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          iconTheme: IconThemeData(color: context.textTheme.headline6?.color),
          title: Text(
            appLocale.adhan_visibility,
            style: TextStyle(color: context.textTheme.headline6?.color),
          )),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SettingsToggle(
              onToggle: (newVal) {
                adhanDependency.changeVisibility(ADHAN_TYPE_SUNRISE, newVal);
              },
              title: appLocale.getAdhanName(ADHAN_TYPE_SUNRISE),
              value: adhanDependency.getVisibility(ADHAN_TYPE_SUNRISE),
              leading: null),
          SettingsToggle(
              onToggle: (newVal) {
                adhanDependency.changeVisibility(ADHAN_TYPE_MIDNIGHT, newVal);
              },
              title: appLocale.getAdhanName(ADHAN_TYPE_MIDNIGHT),
              value: adhanDependency.getVisibility(ADHAN_TYPE_MIDNIGHT),
              leading: null),
          SettingsToggle(
              onToggle: (newVal) {
                adhanDependency.changeVisibility(ADHAN_TYPE_THIRD_NIGHT, newVal);
              },
              title: appLocale.getAdhanName(ADHAN_TYPE_THIRD_NIGHT),
              value: adhanDependency.getVisibility(ADHAN_TYPE_THIRD_NIGHT),
              leading: null),
        ],
      ),
    );
  }
}
