import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/models/LocationInfo.dart';
import 'package:minimal_adhan/prviders/TasbihProvider.dart';
import 'package:minimal_adhan/screens/Home/widgets/NavigationCards.dart';
import 'package:minimal_adhan/screens/Home/widgets/NavigationPanel.dart';
import 'package:minimal_adhan/screens/Home/widgets/dashBoard.dart';
import 'package:minimal_adhan/screens/Recommandations/recommandations_screen.dart';
import 'package:minimal_adhan/screens/adhan/adhanScreen.dart';
import 'package:minimal_adhan/screens/dua/duaScreen.dart';
import 'package:minimal_adhan/screens/qibla/qiblaScreen.dart';
import 'package:minimal_adhan/screens/settings/settingsScreen.dart';
import 'package:minimal_adhan/screens/tasbih/tasbihScreen.dart';
import 'package:provider/provider.dart';

class HomeContent extends StatefulWidget {
  final void Function([bool?]) toggleDrawer;
  final AnimationController drawerController;
  HomeContent(this.toggleDrawer, this.drawerController);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    {

  Widget _getNavImage(String name, double size) => Image.asset(
        'assets/screen_icons/$name.png',
        width: size,
        fit: BoxFit.fitWidth,
      );


  ScrollController controller = ScrollController();


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {

    controller.addListener(() {
      setState(() {
        closeTopContainer = controller.offset > 20;
      });
    });
    super.initState();
  }

  bool closeTopContainer = false;

  @override
  Widget build(BuildContext context) {
    final appLocale = context.appLocale;

    final iconSize = min(
        156.0, ((context.width - 50) / DASHBOARD_NAVIGATION_ELEMENT_PER_ROW));

    return GestureDetector(
      onPanUpdate: (details) {
        // Swiping in right direction.
        if (details.delta.dx > 0) {
          widget.toggleDrawer(true);
        }

        // Swiping in left direction.
        if (details.delta.dx < 0) {
          widget.toggleDrawer(false);
        }
      },
      child: Stack(
        children: [
          AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: closeTopContainer ? 0 : 1,
              child: DashBoard(),
            ),
          NavigationPanel.build(
            controller: controller,
            children: [
              NavigationCard(
                size: iconSize,
                label: appLocale.adhan,
                child: _getNavImage('ic_azan', iconSize*0.6),
                onPressed: () => context.push(AdhanScreen()),
              ),
              NavigationCard(
                size: iconSize,
                label: appLocale.qibla,
                child: _getNavImage('ic_qibla', iconSize*0.6),
                onPressed: () => context.push(QiblaScreen()),
              ),
              NavigationCard(
                size: iconSize,
                label: appLocale.dua,
                child: _getNavImage('ic_hadith', iconSize*0.6),
                onPressed: () => context.push(DuaScreen()),
              ),
              NavigationCard(
                size: iconSize,
                label: 'Tasbih',
                child: _getNavImage('ic_tasbih', iconSize*0.6),
                onPressed: () => context.push(ChangeNotifierProvider(
                  create: (_) => TasbihProvider(),
                  child: TasbihScreen(),
                )),
              ),
              NavigationCard(
                  label: 'More',
                  size: iconSize,
                  child: _getNavImage('application', iconSize*0.6),
                  onPressed: ()=>context.push(RecommendationScreen()),
                  ),
              NavigationCard(
                label: appLocale.settings,
                size: iconSize,
                child: _getNavImage('ic_settings', iconSize*0.6),
                onPressed: () => context.push(
                  SettingsScreen(),
                ),
              ),
            ],
          ),
          AnimatedOpacity(
            opacity: closeTopContainer? 0: 1,
            duration: const Duration(milliseconds: 200),
            child: closeTopContainer ? null : IconButton(
              onPressed: () => widget.toggleDrawer(),
              icon: AnimatedIcon(
                icon: AnimatedIcons.menu_arrow,
                progress: widget.drawerController,
              ),
            ),
          ),
        ],
      ),
    );
  }


}