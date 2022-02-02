import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/helpers/GPS_location_helper.dart';
import 'package:minimal_adhan/prviders/adhanProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/screens/adhan/widgets/AdhanAvailableScreen.dart';
import 'package:minimal_adhan/screens/locationFindingScreen.dart';
import 'package:minimal_adhan/screens/locationNotAvailableScreen.dart';
import 'package:minimal_adhan/screens/unknownErrorScreen.dart';
import 'package:provider/provider.dart';

class AdhanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final adhanDep = context.watch<AdhanDependencyProvider>();
    final appLocale = context.appLocale;
    final locationState = adhanDep.locationState;

    return Scaffold(
      body: SafeArea(
        child: (locationState is LocationAvailable)
            ? ChangeNotifierProvider(
                create: (_) => AdhanProvider(
                    adhanDep, locationState.locationInfo, context.appLocale),
                child: AdhanAvailableScreen(locationState.locationInfo))
            : (locationState is LocationFinding)
                ? LocationFindingScreen()
                : (locationState is LocationNotAvailable)
                    ? LocationNotAvailableScreen(locationState)
                    : UnknownErrorScreen(),
      ),
    );
  }

  const AdhanScreen();
}
