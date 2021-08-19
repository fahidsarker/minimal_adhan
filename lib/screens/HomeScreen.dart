import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minimal_adhan/screens/adhan/adhanScreen.dart';
import 'package:minimal_adhan/screens/dua/duaScreen.dart';
import 'package:minimal_adhan/screens/qibla/qiblaScreen.dart';
import 'package:minimal_adhan/screens/settings/settingsScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'dashboard/dashboardScreen.dart';

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

  @override
  void initState() {
    _controller = PageController();
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
          onTap: (val) => _controller.jumpToPage(val,),
        ),
      ),
    );
  }
}
