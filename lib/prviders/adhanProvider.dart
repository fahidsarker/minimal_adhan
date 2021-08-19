import 'package:flutter/material.dart';
import 'package:minimal_adhan/models/Adhan.dart';
import 'package:minimal_adhan/models/LocationInfo.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:adhan/adhan.dart' as AdhanLib;
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:minimal_adhan/screens/adhan/widgets/AdhanItem.dart';

const ADHAN_TYPE_ANY = -1;
const ADHAN_TYPE_FAJR = 0;
const ADHAN_TYPE_SUNRISE = 1;
const ADHAN_TYPE_DHUHR = 2;
const ADHAN_TYPE_ASR = 3;
const ADHAN_TYPE_MAGRIB = 4;
const ADHAN_TYPE_ISHA = 5;
const ADHAN_TYPE_MIDNIGHT = 6;
const ADHAN_TYPE_THIRD_NIGHT = 7;

class AdhanProvider with ChangeNotifier {
  DateTime _viewingDate;

  AdhanDependencyProvider adhanDependencyProvider;
  LocationInfo locationInfo;
  AppLocalizations appLocalization;

  AdhanProvider(
      this.adhanDependencyProvider, this.locationInfo, this.appLocalization)
      : _viewingDate = DateTime.now();

  int? get currentAdhanIndex {
    if(_viewingDate.isToday){
      final adhans = getAdhanData(_viewingDate);
      for(int i=0; i<adhans.length; i++){
        if(adhans[i].isCurrent)
          return i;
      }
    }
    return null;
  }

  Adhan? get currentAdhan {
    final index = currentAdhanIndex;
    if(index != null)
      return getAdhanData(_viewingDate)[index];

    return null;
  }

  DateTime get currentDate {
    return _viewingDate;
  }

  void changeDayOfDate(int days) {
    _viewingDate = DateTime.now().add(Duration(days: days));
    notifyListeners();
  }

  Adhan get nextAdhan {
    final List<Adhan> fullList = [];
    fullList.addAll(getAdhanData(_viewingDate));

    final currentTime = _viewingDate;
    final filteredList = fullList
        .where((element) => element.startTime.isAfter(currentTime))
        .toList();

    if (filteredList.length < 3) {
      filteredList
          .addAll(getAdhanData(DateTime.now().add(const Duration(days: 1))));
    }

    return filteredList[0];
  }

  Adhan createAdhan(
      {required int type,
      required DateTime startTime,
      required DateTime endTime,
      required DateTime startingPrayerTime,
      required bool shouldCorrect}) {
    return Adhan(
        type: type,
        title: appLocalization.getAdhanName(type),
        startTime: startTime,
        endTime: endTime,
        notifyBefore: adhanDependencyProvider.getNotifyBefore(type),
        manualCorrection: adhanDependencyProvider.getManualCorrection(type),
        notifyID: adhanDependencyProvider.notifyID(type),
        localCode: appLocalization.locale,
        startingPrayerTime: startingPrayerTime,
        shouldCorrect: shouldCorrect);
  }

  List<Adhan> getAdhanData(DateTime date) {
    final _prayerTimes = AdhanLib.PrayerTimes(
        AdhanLib.Coordinates(locationInfo.latitude, locationInfo.longitude),
        AdhanLib.DateComponents.from(date),
        adhanDependencyProvider.params);
    final sunnahTimes = AdhanLib.SunnahTimes(_prayerTimes);

    return [
      createAdhan(
          type: ADHAN_TYPE_FAJR,
          startTime: _prayerTimes.fajr,
          endTime: _prayerTimes.sunrise,
          startingPrayerTime: _prayerTimes.fajr,
          shouldCorrect: date.isToday),
      if (adhanDependencyProvider.getVisibility(ADHAN_TYPE_SUNRISE))
        createAdhan(
            type: ADHAN_TYPE_SUNRISE,
            startTime: _prayerTimes.sunrise,
            endTime: _prayerTimes.sunrise.add(const Duration(minutes: 15)),
            startingPrayerTime: _prayerTimes.fajr,
            shouldCorrect: date.isToday),
      createAdhan(
          type: ADHAN_TYPE_DHUHR,
          startTime: _prayerTimes.dhuhr,
          endTime: _prayerTimes.asr,
          startingPrayerTime: _prayerTimes.fajr,
          shouldCorrect: date.isToday),
      createAdhan(
          type: ADHAN_TYPE_ASR,
          startTime: _prayerTimes.asr,
          endTime: _prayerTimes.maghrib,
          startingPrayerTime: _prayerTimes.fajr,
          shouldCorrect: date.isToday),
      createAdhan(
          type: ADHAN_TYPE_MAGRIB,
          startTime: _prayerTimes.maghrib,
          endTime: _prayerTimes.isha,
          startingPrayerTime: _prayerTimes.fajr,
          shouldCorrect: date.isToday),
      createAdhan(
          type: ADHAN_TYPE_ISHA,
          startTime: _prayerTimes.isha,
          endTime: _prayerTimes.fajr.add(const Duration(days: 1)),
          startingPrayerTime: _prayerTimes.fajr,
          shouldCorrect: date.isToday),
      if (adhanDependencyProvider.getVisibility(ADHAN_TYPE_MIDNIGHT))
        createAdhan(
            type: ADHAN_TYPE_MIDNIGHT,
            startTime: sunnahTimes.middleOfTheNight,
            endTime: sunnahTimes.lastThirdOfTheNight,
            startingPrayerTime: _prayerTimes.fajr,
            shouldCorrect: date.isToday),
      if (adhanDependencyProvider.getVisibility(ADHAN_TYPE_THIRD_NIGHT))
        createAdhan(
            type: ADHAN_TYPE_THIRD_NIGHT,
            startTime: sunnahTimes.lastThirdOfTheNight,
            endTime: _prayerTimes.fajr.add(const Duration(days: 1)),
            startingPrayerTime: _prayerTimes.fajr,
            shouldCorrect: date.isToday),
    ];
  }
}
