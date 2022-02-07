import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/prviders/adhanProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/screens/settings/widgets/SettingsTile.dart';
import 'package:provider/provider.dart';

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
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          SettingsToggle(
            onToggle: (newVal) {
              adhanDependency.changeVisibility(adhanTypeSunrise, visible: newVal);
            },
            title: appLocale.getAdhanName(adhanTypeSunrise),
            value: adhanDependency.getVisibility(adhanTypeSunrise),
          ),
          SettingsToggle(
            onToggle: (newVal) {
              adhanDependency.changeVisibility(adhanTypeMidnight, visible: newVal);
            },
            title: appLocale.getAdhanName(adhanTypeMidnight),
            value: adhanDependency.getVisibility(adhanTypeMidnight),
          ),
          SettingsToggle(
            onToggle: (newVal) {
              adhanDependency.changeVisibility(adhanTypeThirdNight, visible: newVal);
            },
            title: appLocale.getAdhanName(adhanTypeThirdNight),
            value: adhanDependency.getVisibility(adhanTypeThirdNight),
          ),
        ],
      ),
    );
  }
}
