import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/models/LocationInfo.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/GlobalDependencyProvider.dart';
import 'package:minimal_adhan/screens/Home/widgets/HomeContent.dart';
import 'package:minimal_adhan/screens/Home/widgets/menu.dart';
import 'package:minimal_adhan/theme.dart';
import 'package:minimal_adhan/widgets/AnimatedDrawer/views/animated_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:provider/src/provider.dart';

class Home extends StatefulWidget {
  final AdhanDependencyProvider adhanDependencyProvider;

  Home(this.adhanDependencyProvider);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  bool _isOpen = false;

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

  late final AnimationController _animationController;


  @override
  void initState() {
    _disableBatteryOptimization();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    widget.adhanDependencyProvider.updateLocationWithGPS(background: true);
    super.initState();
  }

  void _toggleDrawer([bool? open]){
    if(open != null || open != _isOpen){
      setState(() {
        _isOpen = open ?? !_isOpen;
      });
      if (_isOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedDrawer(
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
            child: Stack(
              children: [
                HomeContent(_toggleDrawer, _animationController),
                if (_isOpen) GestureDetector(
                  onTap: ()=> _toggleDrawer(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
