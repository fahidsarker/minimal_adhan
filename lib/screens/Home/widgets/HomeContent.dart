import 'dart:math';

import 'package:animated_drawer/views/animated_drawer.dart';
import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/models/LocationInfo.dart';
import 'package:minimal_adhan/prviders/TasbihProvider.dart';
import 'package:minimal_adhan/screens/Home/widgets/NavigationCards.dart';
import 'package:minimal_adhan/screens/Home/widgets/NavigationPanel.dart';
import 'package:minimal_adhan/screens/Home/widgets/dashBoard.dart';
import 'package:minimal_adhan/screens/Home/widgets/menu.dart';
import 'package:minimal_adhan/screens/adhan/adhanScreen.dart';
import 'package:minimal_adhan/screens/dua/duaScreen.dart';
import 'package:minimal_adhan/screens/qibla/qiblaScreen.dart';
import 'package:minimal_adhan/screens/settings/settingsScreen.dart';
import 'package:minimal_adhan/screens/tasbih/tasbihScreen.dart';
import 'package:provider/provider.dart';

class HomeContent extends StatelessWidget {
  final LocationInfo _locationInfo;

  HomeContent(this._locationInfo);

  Widget _getNavImage(String name) => Image.asset(
        'assets/screen_icons/$name.png',
        width: 96,
        fit: BoxFit.fitWidth,
      );

  @override
  Widget build(BuildContext context) {
    final appLocale = context.appLocale;

    final iconSize = min(
        156.0, ((context.width - 50) / DASHBOARD_NAVIGATION_ELEMENT_PER_ROW));
    final drawerIconColor = Theme.of(context).accentColor;
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () => context.push(SettingsScreen()),
                    icon: Icon(Icons.settings))
              ],
            ),
            DashBoard(_locationInfo),
            NavigationPanel.build(
              children: [
                NavigationCard(
                    size: iconSize,
                    label: appLocale.adhan,
                    child: _getNavImage('ic_azan'),
                    backgroundColor: Colors.white.withOpacity(0.2),
                    navTo: AdhanScreen()),
                NavigationCard(
                    size: iconSize,
                    label: appLocale.qibla,
                    child: _getNavImage('ic_qibla'),
                    backgroundColor: Colors.white.withOpacity(0.2),
                    navTo: QiblaScreen()),
                NavigationCard(
                    size: iconSize,
                    label: appLocale.dua,
                    child: _getNavImage('ic_dua'),
                    backgroundColor: Colors.white.withOpacity(0.2),
                    navTo: DuaScreen()),
                NavigationCard(
                    size: iconSize,
                    label: 'Tasbih',
                    child: _getNavImage('ic_tasbih'),
                    backgroundColor: Colors.white.withOpacity(0.2),
                    navTo: ChangeNotifierProvider(
                        create: (_) => TasbihProvider(),
                        child: TasbihScreen())),
              ],
            ),
          ],
        ));
  }
}
