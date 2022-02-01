import 'package:flutter/material.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/screens/Home/HomeScreenAvailable.dart';
import 'package:provider/src/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locationState =
        context.watch<AdhanDependencyProvider>().locationState;
    final adhanDependency = context.watch<AdhanDependencyProvider>();
    return Scaffold(
      body: SafeArea(
          child: HomeScreenAvalilable(adhanDependency))
    );
  }
}
