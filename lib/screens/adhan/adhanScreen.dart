import 'package:flutter/material.dart';
import 'package:minimal_adhan/helpers/GPS_location_helper.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/screens/adhan/widgets/AdhanAvailableScreen.dart';
import 'package:minimal_adhan/screens/locationFindingScreen.dart';
import 'package:minimal_adhan/screens/locationNotAvailableScreen.dart';
import 'package:minimal_adhan/screens/unknownErrorScreen.dart';
import 'package:provider/provider.dart';

class AdhanScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final locationState = context.watch<AdhanDependencyProvider>().locationState;

    return SafeArea(
      child: (locationState is LocationAvailable)
          ? AdhanAvailableScreen(locationState.locationInfo)
          : (locationState is LocationFinding)
          ? LocationFindingScreen()
          : (locationState is LocationNotAvailable)
          ? LocationNotAvailableScreen(locationState)
          : UnknownErrorScreen(),
    );
  }

const  AdhanScreen();
}
