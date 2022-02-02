import 'package:geocoding/geocoding.dart' as Geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:minimal_adhan/helpers/sharedprefKeys.dart';
import 'package:minimal_adhan/models/LocationInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

const LOCATION_NA_CAUSE_PERMISSION_DENIED =
    'Permission Denied. Please check settings.';
const LOCATION_NA_CAUSE_PERMISSION_DENIED_FOREVER =
    'Permission Denied Forever. Please check settings.';
const LOCATION_NA_CAUSE_LAT_LONG_NULL = 'Your location seems to be corrupted.';
const LOCATION_NA_CAUSE_GPS_NOT_ENABLED =
    'Your Location Provider is disabled. Please enable it and try again!';
const LOCATION_NA_CAUSE_FINDING = 'Finding Your Location! Please wait.';

class LocationHelper {
  Future<LocationState> getLocationFromGPS({required bool background}) async {
    final pref = await SharedPreferences.getInstance();
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled && !background) {
      await Geolocator.openLocationSettings();
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
    }
    if (!serviceEnabled) {
      return LocationNotAvailable(LOCATION_NA_CAUSE_GPS_NOT_ENABLED);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied && !background) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationNotAvailable(LOCATION_NA_CAUSE_PERMISSION_DENIED);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationNotAvailable(LOCATION_NA_CAUSE_PERMISSION_DENIED_FOREVER);
    }

    final position = await Geolocator.getCurrentPosition();
    final lat = position.latitude;
    final long = position.longitude;
    String address = '($lat, $long)';

    try {
      List<Geocoding.Placemark> placemarks =
          await Geocoding.placemarkFromCoordinates(lat, long,
              localeIdentifier:
                  pref.getString(KEY_ADHAN_CURRENT_LOCALIZATION) ??
                      DEFAULT_ADHAN_CURRENT_LOCALIZATION);
      if (placemarks.length > 0) {
        var name = placemarks[0].name;
        if (name != null) {
          address = name;
        }
      }
    } catch (e) {}

    await pref.setDouble(KEY_LOCATION_LATITUDE, lat);
    await pref.setDouble(KEY_LOCATION_LONGITUDE, long);
    await pref.setString(KEY_LOCATION_ADDRESS, address);

    return LocationAvailable(
        LocationInfo(lat, long, address, LocationMode.LIVE));
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
