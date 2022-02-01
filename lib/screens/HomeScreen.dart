import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/helpers/sharedPrefHelper.dart';
import 'package:minimal_adhan/prviders/dependencies/GlobalDependencyProvider.dart';
import 'package:minimal_adhan/screens/adhan/adhanScreen.dart';
import 'package:minimal_adhan/screens/dua/duaScreen.dart';
import 'package:minimal_adhan/screens/qibla/qiblaScreen.dart';
import 'package:minimal_adhan/screens/settings/settingsScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:optimize_battery/optimize_battery.dart';
import 'package:provider/src/provider.dart';

import 'dashboard/dashboardScreen.dart';

@Deprecated('Use Home now')
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;
  late final PageController _controller;

  final _screens = [
    DashBoardScreen(),
    AdhanScreen(),
    QiblaScreen(),
    DuaScreen(),
    SettingsScreen()
  ];

  void _disableBatteryOptimization() async {
    if (Platform.isAndroid) {
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        final appLocale = AppLocalizations.of(context) ?? AppLocalizationsEn();
        final globalDep = context.read<GlobalDependencyProvider>();

        if (globalDep.needToShowDiableBatteryOptimizeDialog) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(appLocale.disable_battery_optimization),
              content: Text(appLocale.disable_battery_optimization_desc),
              actions: [
                TextButton(
                    onPressed: () {
                      context.pop();
                      globalDep.disableBatteryOptimization();
                    },
                    child: Text(appLocale.bttn_okay)),
                TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Text(appLocale.bttn_remind_me_later)),
                TextButton(
                    onPressed: () {
                      context.pop();
                      globalDep.setNeverAskDisableBatteryOptimize();
                    },
                    child: Text(
                      appLocale.bttn_never_ask_again,
                      style: TextStyle(color: Colors.redAccent),
                    )),
              ],
            ),
          );
        }
      });
    }
  }

  @override
  void initState() {
    _controller = PageController();
    _disableBatteryOptimization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context)!;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness:
            Theme.of(context).brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: PageView.builder(
          physics: BouncingScrollPhysics(),
          itemBuilder: (ctx, i) => _screens[i],
          itemCount: _screens.length,
          controller: _controller,
          onPageChanged: (val) => setState(
            () {
              _currentPageIndex = val;
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), label: appLocale.dashboard),
            BottomNavigationBarItem(
                icon: Icon(Icons.timer), label: appLocale.adhan),
            BottomNavigationBarItem(
                icon: Icon(Icons.compass_calibration), label: appLocale.qibla),
            BottomNavigationBarItem(
                icon: Icon(Icons.short_text_sharp), label: appLocale.dua),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: appLocale.settings),
          ],
          currentIndex: _currentPageIndex,
          onTap: (val) => _controller.jumpToPage(
            val,
          ),
        ),
      ),
    );
  }
}
