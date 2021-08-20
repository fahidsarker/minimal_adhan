import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:minimal_adhan/models/Adhan.dart';
import 'package:minimal_adhan/models/LocationInfo.dart';
import 'package:minimal_adhan/prviders/adhanProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';

class AdhanNotificationProvider extends AdhanProvider {
  AdhanNotificationProvider(AdhanDependencyProvider adhanDependencyProvider,
      LocationInfo locationInfo, AppLocalizations appLocalization)
      : super(adhanDependencyProvider, locationInfo, appLocalization);

  Adhan? get notificationAdhan {
    final list = getAdhanData(DateTime.now())
      ..forEach((element) {
        element.modifyForNotification();
      });

    return list.firstWhere(
        (element) =>
            element.isCurrent &&
            (adhanDependencyProvider.showPersistant ||
                adhanDependencyProvider.notifyID(element.type) != 0),
        orElse: () => null as Adhan);
  }

  Adhan? get nextNotifcationAdhan {
    final List<Adhan> fullList = [];
    final currentTime = DateTime.now();
    fullList.addAll(getAdhanData(currentTime));
    fullList.addAll(getAdhanData(DateTime.now().add(const Duration(days: 1))));
    fullList.addAll(getAdhanData(DateTime.now().add(const Duration(days: 2))));

    fullList.forEach((element) {
      element.modifyForNotification();
    });

    final filteredList = fullList
        .where((element) =>
            element.startTime.isAfter(currentTime) &&
            (adhanDependencyProvider.showPersistant || adhanDependencyProvider.notifyID(element.type) != 0))
        .toList();

    if (filteredList.length > 0) {
      return filteredList[0];
    } else {
      return null;
    }
  }
}
