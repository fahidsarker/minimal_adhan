import 'package:flutter/material.dart';
import 'package:minimal_adhan/helpers/GPS_location_helper.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:provider/provider.dart';
class LocationNotAvailableScreen extends StatelessWidget {

  final LocationNotAvailable _locationNotAvailable;


  LocationNotAvailableScreen(this._locationNotAvailable);

  @override
  Widget build(BuildContext context) {
    final adhanProvider = context.read<AdhanDependencyProvider>();
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Location Not available!'),
          Text('Reason: ${_locationNotAvailable.cause}'),
          TextButton(onPressed: () => adhanProvider.updateLocationWithGPS(background: false), child: Text('Try Again'))
        ],
      ),
    );
  }
}
