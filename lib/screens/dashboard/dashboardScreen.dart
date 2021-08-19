import 'package:flutter/material.dart';
import 'package:minimal_adhan/helpers/GPS_location_helper.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/screens/dashboard/dashBoardAvailableScreen.dart';
import 'package:provider/provider.dart';

import '../locationFindingScreen.dart';
import '../locationNotAvailableScreen.dart';
import '../unknownErrorScreen.dart';

class DashBoardScreen extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    final locationState = context.watch<AdhanDependencyProvider>().locationState;

    return SafeArea(
      child: (locationState is LocationAvailable)
          ? DashBoardAvailable(locationState.locationInfo)
          : (locationState is LocationFinding)
          ? LocationFindingScreen()
          : (locationState is LocationNotAvailable)
          ? LocationNotAvailableScreen(locationState)
          : UnknownErrorScreen(),
    );
  }

  const DashBoardScreen();
}
