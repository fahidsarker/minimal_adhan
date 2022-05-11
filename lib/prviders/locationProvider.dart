import 'package:flutter/cupertino.dart';
import 'package:minimal_adhan/helpers/gps_location_helper.dart';
import 'package:minimal_adhan/helpers/notification/notifiers.dart';
import 'package:minimal_adhan/helpers/preferences.dart';
import 'package:minimal_adhan/models/LocationInfo.dart';

class LocationProvider with ChangeNotifier {

  LocationProvider() : _locationHelper = const LocationHelper();

  final LocationHelper _locationHelper;
  static LocationState _locationState =
      LocationNotAvailable(locationNACauseFinding);

  LocationState get locationState => _locationState;

  Future<void> init() async {
    final loc = getPersistantLocation();
    if (loc != null) {
      _locationState = LocationAvailable(loc);
    } else {
      final welcomeShown = sharedPrefWelcomeShown.value;
      if (welcomeShown) {
        _locationState =
            await _locationHelper.getLocationFromGPS(background: false);
      } else {
        _locationState = LocationNotAvailable(locationNACausePermissionDenied);
      }
    }
  }

  Future<void> updateLocationWithGPS({required bool background}) async {
    if (!background) {
      _locationState = LocationFinding();
      notifyListeners();
    }

    LocationState state =
        await _locationHelper.getLocationFromGPS(background: background);
    if (state is LocationNotAvailable) {
      final loc = getPersistantLocation();
      if (loc != null) {
        state = LocationAvailable(loc);
      }
    }
    _locationState = state;
    notifyListeners();
  }

  ///Get Location from sharedpref and returns a LocationInfo obj
  LocationInfo? getPersistantLocation() {
    final lat = sharedPrefLocationLatitude.value;
    final long = sharedPrefLocationLongitude.value;
    final adr = sharedPrefLocationAddress.value;

    LocationInfo? newLoc;
    if (lat != null && long != null && adr != null) {
      newLoc = LocationInfo(lat, long, adr, LocationMode.CACHED);
    }
    return newLoc;
  }

  @override
  void notifyListeners() async {
    final locationState = _locationState;
    if (locationState is LocationAvailable) {
      scheduleNotification(showNowIfPersistent: true);
    }
    super.notifyListeners();
  }

  String get addressAsString{
    if(locationState is LocationAvailable){
      return  (locationState as LocationAvailable).locationInfo.address;
    }else if (locationState is LocationFinding){
      return 'Finding...'; //todo change to app locale
    }else {
      return 'UNKNOWN ERROR'; // todo change to app locale
    }
  }
}
