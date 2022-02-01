import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/helpers/GPS_location_helper.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:provider/provider.dart';

class LocationNotAvailableScreen extends StatelessWidget {
  final LocationNotAvailable _locationNotAvailable;

  LocationNotAvailableScreen(this._locationNotAvailable);

  @override
  Widget build(BuildContext context) {
    final adhanProvider = context.read<AdhanDependencyProvider>();
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
              Text('Location Not available!'),
              Text(
                '${_locationNotAvailable.cause}',
                style: context.textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              TextButton(
                  onPressed: () =>
                      adhanProvider.updateLocationWithGPS(background: false),
                  child: Text('Try Again'))
            ],
          ),
        ),
      ),
    );
  }
}
