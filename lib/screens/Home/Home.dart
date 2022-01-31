import 'package:flutter/material.dart';
import 'package:minimal_adhan/helpers/GPS_location_helper.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/screens/Home/HomeScreenAvailable.dart';
import 'package:provider/src/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locationState =
        context.watch<AdhanDependencyProvider>().locationState;

    return Scaffold(
      body: SafeArea(
          child: HomeScreenAvalilable((locationState as LocationAvailable)
              .locationInfo)), //todo check dynamically
    );
  }
}
