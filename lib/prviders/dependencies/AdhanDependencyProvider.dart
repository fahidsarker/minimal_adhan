import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:minimal_adhan/helpers/GPS_location_helper.dart';
import 'package:minimal_adhan/helpers/notification/notifiers.dart';
import 'package:minimal_adhan/helpers/sharedPrefHelper.dart';
import 'package:minimal_adhan/helpers/sharedprefKeys.dart';
import 'package:minimal_adhan/helpers/adhan_dependencies.dart';
import 'package:minimal_adhan/models/LocationInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:minimal_adhan/extensions.dart';

class AdhanDependencyProvider with ChangeNotifier {
  late int madhabIndex;
  late int calMethodIndex;
  late int highLatRuleIndex;
  late bool showPersistant;
  final LocationHelper _locationHelper;
  LocationState _locationState;

  var _visibility = DEFAULT_ADHAN_VISIBILITY;
  var _manualCorrections = DEFAULT_ADHAN_MANUAL_CORRECT;
  var _notifyIDs = DEFAULT_ADHAN_NOTIFY_ID;
  var __notifyBefore = DEFAULT_ADHAN_NOTIFY_BEFORE;

  //final NotificationManager _notificationManager;

  AdhanDependencyProvider()
      : _locationState = LocationNotAvailable(LOCATION_NA_CAUSE_FINDING),
        _locationHelper = LocationHelper();
        //_notificationManager = NotificationManager();

  ///initialize every dependency
  Future<void> init() async {
    await sharedPref((preference) async{
      madhabIndex =
          preference.getInt(KEY_ADHAN_MADHAB_INDEX) ?? DEFAULT_ADHAN_MADHAB_INDEX;
      calMethodIndex =
          preference.getInt(KEY_ADHAN_CALC_INDEX) ?? DEFAULT_ADHAN_CALC_INDEX;
      highLatRuleIndex = preference.getInt(KEY_ADHAN_HIGH_LAT_INDEX) ??
          DEFAULT_ADHAN_HIGH_LAT_INDEX;

      final vis = preference.getStringList(KEY_ADHAN_VISIBILITY);
      if (vis != null) {
        _visibility = vis.map((e) => e.toBool()).toList();
      }

      final manualCor = preference.getStringList(KEY_ADHAN_MANUAL_CORRECT);
      if (manualCor != null) {
        _manualCorrections = manualCor.map((e) => int.parse(e)).toList();
      }

      final shouldNotifies = preference.getStringList(KEY_ADHAN_NOTIFY_ID);
      if (shouldNotifies != null) {
        _notifyIDs = shouldNotifies.map((e) => int.parse(e)).toList();
      }

      final notifyBefores = preference.getStringList(KEY_ADHAN_NOTIFY_BEFORE);
      if(notifyBefores != null){
        __notifyBefore = notifyBefores.map((e) => int.parse(e)).toList();
      }

      final notifyBefore = preference.getStringList(KEY_ADHAN_NOTIFY_BEFORE);
      if (notifyBefore != null) {
        __notifyBefore = notifyBefore.map((e) => int.parse(e)).toList();
      }

      showPersistant = preference.getBool(KEY_ADHAN_SHOW_PERSISTANT_NOTIFY) ?? DEFAULT_ADHAN_SHOW_PERSISTANT_NOTIFY;

      ///check if previous location is present
      final loc = getPersistantLocation(preference);
      if (loc != null) {
        _locationState = LocationAvailable(loc);
      } else {
        final welcomeShown =
            preference.getBool(KEY_WELCOME_SCREEN_SHOWN) ?? false;
        if (welcomeShown) {
          _locationState = await _locationHelper.getLocationFromGPS(background: false);
        } else {
          _locationState =
              LocationNotAvailable(LOCATION_NA_CAUSE_PERMISSION_DENIED);
        }
      }
    });

    //await _notificationManager.initialize();
  }



  LocationState get locationState {
    return _locationState;
  }

  @override
  void notifyListeners() async {
    final locationState = _locationState;
    if (locationState is LocationAvailable) {
      scheduleNotification(showNowIfPersistent: true);
    }
    super.notifyListeners();
  }

  void changePersistantNotifyStatus(bool newVal)async{
    final success = await setBoolToSharedPref(KEY_ADHAN_SHOW_PERSISTANT_NOTIFY, newVal);
    if(success){
      showPersistant = newVal;
      if(!newVal){
         await cancelAllNotifications();
      }else{
        createNotification(forcedSilent: true, reschedule: false);
      }
      notifyListeners();
    }
  }

  void updateLocationWithGPS({required bool background}) async {
    if(!background){
      _locationState = LocationFinding();
      notifyListeners();
    }
    final pref = await getSharedPref();

    LocationState state = await _locationHelper.getLocationFromGPS(background:background);
    //State is either location available or not available

    if (state is LocationNotAvailable) {
      final loc = getPersistantLocation(pref);
      if (loc != null) {
        state = LocationAvailable(loc);
      }
    }
    _locationState = state;
    notifyListeners();
  }

  ///Get Location from sharedpref and returns a LocationInfo obj
  LocationInfo? getPersistantLocation(SharedPreferences pref) {
    final lat = pref.getDouble(KEY_LOCATION_LATITUDE);
    final long = pref.getDouble(KEY_LOCATION_LONGITUDE);
    final adr = pref.getString(KEY_LOCATION_ADDRESS);

    LocationInfo? newLoc;
    if (lat != null && long != null && adr != null) {
      newLoc = LocationInfo(lat, long, adr, LocationMode.CACHED);
    }
    return newLoc;
  }



  CalculationParameters get params {
    final param = CALCULATION_METHODS[calMethodIndex].getParameters();
    param.madhab = MADHABS[madhabIndex];
    param.highLatitudeRule = HIGHE_LAT_RULES[highLatRuleIndex];
    return param;
  }

  int getNotifyBefore(int adhanType){
    return __notifyBefore[adhanType];
  }

  String get paranName {
    return CALCULATION_METHOD_NAMES[calMethodIndex];
  }

  String get paranDesc {
    return CALCULATION_METHOD_DESCS[calMethodIndex];
  }

  String get highLatRuleName {
    return HIGHE_LAT_RULES_NAMES[highLatRuleIndex];
  }

  String get highLatRuleDesc {
    return HIGHE_LAT_RULES_DESCS[highLatRuleIndex];
  }

  bool getVisibility(int adhanID) {
    return _visibility[adhanID];
  }

  int getManualCorrection(int adhanIndex) {
    return _manualCorrections[adhanIndex];
  }

  int notifyID(int adhanType){
    return _notifyIDs[adhanType];
  }



  void silentAll() async {
    final pref = await SharedPreferences.getInstance();
    final success = await pref.setStringList(
        KEY_ADHAN_NOTIFY_ID,
        [0,0,0,0,0,0,0,0]
            .map((e) => e.toString())
            .toList());
    if (success) {
      _notifyIDs = [0,0,0,0,0,0,0,0];
      notifyListeners();
    }
  }

  void changeMadhab(int newMadhabIndex) async {
    final pref = await SharedPreferences.getInstance();
    final success = await pref.setInt(KEY_ADHAN_MADHAB_INDEX, newMadhabIndex);
    if (success) {
      madhabIndex = newMadhabIndex;
      notifyListeners();
    }
  }

  void changeCalMethod(int newCalcMethod) async {
    final pref = await SharedPreferences.getInstance();
    final success = await pref.setInt(KEY_ADHAN_CALC_INDEX, newCalcMethod);
    if (success) {
      calMethodIndex = newCalcMethod;
      notifyListeners();
    }
  }

  void changeHighLatRuleIndex(int newIndex) async {
    final pref = await SharedPreferences.getInstance();
    final success = await pref.setInt(KEY_ADHAN_HIGH_LAT_INDEX, newIndex);
    if (success) {
      highLatRuleIndex = newIndex;
      notifyListeners();
    }
  }

  void changeVisibility(int adhanID, bool visible) async {
    final pref = await SharedPreferences.getInstance();
    _visibility[adhanID] = visible;
    await pref.setStringList(
        KEY_ADHAN_VISIBILITY, _visibility.map((e) => e.toString()).toList());
    notifyListeners();
  }

  void changeManualCorrection(int adhanID, int minute) async {
    final pref = await SharedPreferences.getInstance();
    _manualCorrections[adhanID] = minute;
    await pref.setStringList(KEY_ADHAN_MANUAL_CORRECT,
        _manualCorrections.map((e) => e.toString()).toList());
    notifyListeners();
  }

  String get manualCorrectionAll {
    return _manualCorrections.toString();
  }

  void changeNotifyType(int adhanType, int newVal) async{
    final pref = await SharedPreferences.getInstance();
    _notifyIDs[adhanType] = newVal;
    await pref.setStringList(KEY_ADHAN_NOTIFY_ID,
        _notifyIDs.map((e) => e.toString()).toList());
    notifyListeners();
  }

  void changeNotifyDelay(int adhanType, int newVal) async{
    final pref = await SharedPreferences.getInstance();
    __notifyBefore[adhanType] = newVal;
    await pref.setStringList(KEY_ADHAN_NOTIFY_BEFORE,
        __notifyBefore.map((e) => e.toString()).toList());
    notifyListeners();
  }

}
