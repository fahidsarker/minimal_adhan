import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/models/LocationInfo.dart';
import 'package:minimal_adhan/screens/Home/widgets/HomeContent.dart';
import 'package:minimal_adhan/screens/Home/widgets/menu.dart';
import 'package:minimal_adhan/theme.dart';
import 'package:minimal_adhan/widgets/AnimatedDrawer/views/animated_drawer.dart';

class HomeScreenAvalilable extends StatefulWidget {
  final LocationInfo _locationInfo;

  HomeScreenAvalilable(this._locationInfo);

  @override
  State<HomeScreenAvalilable> createState() => _HomeScreenAvalilableState();
}

class _HomeScreenAvalilableState extends State<HomeScreenAvalilable> {

  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedDrawer(
      homePageXValue: 60,
      shadowXValue: 10,
      isOpen: _isOpen,
      backgroundGradient: getDrawerBGGradient(context),
      shadowColor: getDrawerShadowColor(context),
      menuPageContent: Menu(),
      homePageContent: Container(
        height: context.height,
        width: context.width,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: HomeContent(widget._locationInfo, (open)=> setState(() => _isOpen = open)),
      ),
    );
  }
}
