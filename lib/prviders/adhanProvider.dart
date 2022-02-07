import 'package:adhan/adhan.dart' as AdhanLib;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/models/Adhan.dart';
import 'package:minimal_adhan/models/LocationInfo.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';

const adhanTypeAny = -1;
const adhanTypeFajr = 0;
const adhanTypeSunrise = 1;
const adhanTypeDhuhr = 2;
const adhanTypeAsr = 3;
const adhanTypeMagrib = 4;
const adhanTypeIsha = 5;
const adhanTypeMidnight = 6;
const adhanTypeThirdNight = 7;

class AdhanProvider with ChangeNotifier {
  DateTime _viewingDate;

  AdhanDependencyProvider adhanDependencyProvider;
  LocationInfo locationInfo;
  AppLocalizations appLocalization;

  AdhanProvider(
      this.adhanDependencyProvider, this.locationInfo, this.appLocalization,)
      : _viewingDate = DateTime.now();

  int? get currentAdhanIndex {
    int? current;
    if (_viewingDate.isToday) {
      final adhans = getAdhanData(_viewingDate);
      for (int i = 0; i < adhans.length; i++) {
        if (adhans[i].isCurrent) {
          current = i;
        }
      }
    }
    return current;
  }

  Adhan? get currentAdhan {
    final index = currentAdhanIndex;
    if (index != null) {
      return getAdhanData(_viewingDate)[index];
    }

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
      required bool shouldCorrect,}) {
    return Adhan(
      type: type,
      title:
          appLocalization.getAdhanName(type, isJummah: startTime.isJummahToday),
      startTime: startTime,
      endTime: endTime,
      notifyBefore: adhanDependencyProvider.getNotifyBefore(type),
      manualCorrection: adhanDependencyProvider.getManualCorrection(type),
      localCode: appLocalization.locale,
      startingPrayerTime: startingPrayerTime,
      shouldCorrect: shouldCorrect,
    );
  }

  List<Adhan> getAdhanData(DateTime date) {
    final _prayerTimes = AdhanLib.PrayerTimes(
      AdhanLib.Coordinates(locationInfo.latitude, locationInfo.longitude),
      AdhanLib.DateComponents.from(date),
      adhanDependencyProvider.params,
    );
    final sunnahTimes = AdhanLib.SunnahTimes(_prayerTimes);

    return [
      createAdhan(
        type: adhanTypeFajr,
        startTime: _prayerTimes.fajr,
        endTime: _prayerTimes.sunrise,
        startingPrayerTime: _prayerTimes.fajr,
        shouldCorrect: date.isToday,
      ),
      if (adhanDependencyProvider.getVisibility(adhanTypeSunrise))
        createAdhan(
          type: adhanTypeSunrise,
          startTime: _prayerTimes.sunrise,
          endTime: _prayerTimes.sunrise.add(const Duration(minutes: 15)),
          startingPrayerTime: _prayerTimes.fajr,
          shouldCorrect: date.isToday,
        ),
      createAdhan(
        type: adhanTypeDhuhr,
        startTime: _prayerTimes.dhuhr,
        endTime: _prayerTimes.asr,
        startingPrayerTime: _prayerTimes.fajr,
        shouldCorrect: date.isToday,
      ),
      createAdhan(
        type: adhanTypeAsr,
        startTime: _prayerTimes.asr,
        endTime: _prayerTimes.maghrib,
        startingPrayerTime: _prayerTimes.fajr,
        shouldCorrect: date.isToday,
      ),
      createAdhan(
        type: adhanTypeMagrib,
        startTime: _prayerTimes.maghrib,
        endTime: _prayerTimes.isha,
        startingPrayerTime: _prayerTimes.fajr,
        shouldCorrect: date.isToday,
      ),
      createAdhan(
        type: adhanTypeIsha,
        startTime: _prayerTimes.isha,
        endTime: _prayerTimes.fajr.add(const Duration(days: 1)),
        startingPrayerTime: _prayerTimes.fajr,
        shouldCorrect: date.isToday,
      ),
      if (adhanDependencyProvider.getVisibility(adhanTypeMidnight))
        createAdhan(
          type: adhanTypeMidnight,
          startTime: sunnahTimes.middleOfTheNight,
          endTime: sunnahTimes.lastThirdOfTheNight,
          startingPrayerTime: _prayerTimes.fajr,
          shouldCorrect: date.isToday,
        ),
      if (adhanDependencyProvider.getVisibility(adhanTypeThirdNight))
        createAdhan(
          type: adhanTypeThirdNight,
          startTime: sunnahTimes.lastThirdOfTheNight,
          endTime: _prayerTimes.fajr.add(const Duration(days: 1)),
          startingPrayerTime: _prayerTimes.fajr,
          shouldCorrect: date.isToday,
        ),
    ];
  }
}
