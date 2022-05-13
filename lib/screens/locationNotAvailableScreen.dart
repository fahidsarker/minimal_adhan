import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/helpers/gps_location_helper.dart';
import 'package:minimal_adhan/prviders/locationProvider.dart';
import 'package:provider/provider.dart';

class LocationNotAvailableScreen extends StatelessWidget {
  final LocationNotAvailable _locationNotAvailable;

  const LocationNotAvailableScreen(this._locationNotAvailable);

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.read<LocationProvider>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/location_na.png',
                width: 128,
              ),
               Text(context.appLocale.no_location_available),
              Text(
                '${_locationNotAvailable.cause}',
                style: context.textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              TextButton(
                  onPressed: () =>
                      locationProvider.updateLocationWithGPS(background: false),
                  child:  Text(context.appLocale.try_again),)
            ],
          ),
        ),
      ),
    );
  }
}
