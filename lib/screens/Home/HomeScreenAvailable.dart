import 'dart:math';

import 'package:animated_drawer/views/animated_drawer.dart';
import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/models/LocationInfo.dart';
import 'package:minimal_adhan/screens/Home/widgets/HomeContent.dart';
import 'package:minimal_adhan/screens/Home/widgets/NavigationCards.dart';
import 'package:minimal_adhan/screens/Home/widgets/NavigationPanel.dart';
import 'package:minimal_adhan/screens/Home/widgets/dashBoard.dart';
import 'package:minimal_adhan/screens/Home/widgets/menu.dart';
import 'package:minimal_adhan/screens/adhan/adhanScreen.dart';
import 'package:minimal_adhan/screens/dua/duaScreen.dart';
import 'package:minimal_adhan/screens/qibla/qiblaScreen.dart';
import 'package:minimal_adhan/screens/tasbih/tasbihScreen.dart';

class HomeScreenAvalilable extends StatelessWidget {
  final LocationInfo _locationInfo;

  HomeScreenAvalilable(this._locationInfo);



  @override
  Widget build(BuildContext context) {


    return AnimatedDrawer(
        homePageXValue: 60,
        shadowXValue: 10,
        backgroundGradient: const LinearGradient(
          colors: [
            Color(0xFF134E5E),
            Color(0xFF71B280),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shadowColor: Colors.teal,
        menuPageContent: Menu(),
        homePageContent: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: HomeContent(_locationInfo)));
  }
}
