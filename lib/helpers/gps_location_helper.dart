import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:minimal_adhan/helpers/preferences.dart';
import 'package:minimal_adhan/models/LocationInfo.dart';

const locationNACausePermissionDenied =
    'Permission Denied. Please check settings.';
const locationNACausePermissionDeniedForever =
    'Permission Denied Forever. Please check settings.';
const locationNACauseLatLongNull = 'Your location seems to be corrupted.';
const locationNACauseGPSNotEnabled =
    'Your Location Provider is disabled. Please enable it and try again!';
const locationNACauseFinding = 'Finding Your Location! Please wait.';

class LocationHelper {
  Future<LocationState> getLocationFromGPS({required bool background}) async {

    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled && !background) {
      await Geolocator.openLocationSettings();
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
    }
    if (!serviceEnabled) {
      return LocationNotAvailable(locationNACauseGPSNotEnabled);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied && !background) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationNotAvailable(locationNACausePermissionDenied);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationNotAvailable(locationNACausePermissionDeniedForever);
    }

    final position = await Geolocator.getCurrentPosition();
    final lat = position.latitude;
    final long = position.longitude;
    String address = '($lat, $long)';

    try {
      final placeMarks = await geocoding.placemarkFromCoordinates(
        lat,
        long,
        localeIdentifier: sharedPrefAdhanCurrentLocalization.value,
      );
      if (placeMarks.isNotEmpty) {
        final name = placeMarks[0].name;
        if (name != null) {
          address = name;
        }
      }
    } catch (_) {}

    sharedPrefLocationLatitude.value = lat;
    sharedPrefLocationLongitude.value = long;
    sharedPrefLocationAddress.value = address;


    return LocationAvailable(
        LocationInfo(lat, long, address, LocationMode.LIVE),);
  }
}

abstract class LocationState {}

class LocationAvailable extends LocationState {
  final LocationInfo locationInfo;

  LocationAvailable(this.locationInfo);

  String locationAddressOfLength(int length) {
    return locationInfo.address.length < length
        ? locationInfo.address
        : '${locationInfo.address.substring(0, length)}...';
  }
}

class LocationFinding extends LocationState {}

class LocationNotAvailable extends LocationState {
  final String cause;

  LocationNotAvailable(this.cause);
}
