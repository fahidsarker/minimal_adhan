import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/helpers/gps_location_helper.dart';
import 'package:minimal_adhan/helpers/preferences.dart';
import 'package:minimal_adhan/models/Adhan.dart';
import 'package:minimal_adhan/models/preference.dart';
import 'package:minimal_adhan/platform_dependents/android_flutter_background_service.dart';
import 'package:minimal_adhan/platform_dependents/method_channel_helper.dart';
import 'package:minimal_adhan/prviders/adhanProvider.dart';
import 'package:minimal_adhan/prviders/ahdanNotificationProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/prviders/locationProvider.dart';

const notifyAdhanIdSilent = 0;
const notifyIDAdhanNormal = 1;
const notifyIDAdhanAlarm = 2;
const notifyIDAdhanRingtone = 3;
const notifyIDAdhanMecca = 4;
const notifyIDAdhanMedina = 5;

Future<FlutterLocalNotificationsPlugin> _initializeNotifiers() async {
  //todo change progaurd rules for release builds (local_notifications)
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_notify');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  final notifier = FlutterLocalNotificationsPlugin();
  await notifier.initialize(initializationSettings);

  return notifier;
}

/// We can not get the uri for alarm and ringtone during
/// notification call back yet due to a bug in flutter
///
/// Hence, we make a backup whenever we get a chance
/// so that we can use that later
Future<void> backupURIs() async {
  try {
    final alarmURI = await getToneURI(notifyIDAdhanAlarm);
    final ringtoneURI = await getToneURI(notifyIDAdhanRingtone);

    await alarmURI?.let((it) async => sharedPrefAdhanAlarmUri.updateValue(it));
    await ringtoneURI
        ?.let((it) async => sharedPrefAdhanAlarmUri.updateValue(it));
  } catch (_) {}
}

Future<void> scheduleNotification({
  DateTime? preDefined,
  bool showNowIfPersistent = false,
}) async {
  backupURIs();

  if (preDefined != null) {
    await _setAlarm(preDefined);
    return;
  }

  await initPreferences();
  final adhanDependency = AdhanDependencyProvider();
  final locationProvider = LocationProvider.getInstance();
  await locationProvider.init();

  final locationState = locationProvider.locationState;

  if (locationState is LocationAvailable) {
    final notificationProvider = AdhanNotificationProvider(
      adhanDependency,
      locationState.locationInfo,
      engAppLocale,
    );
    final nextAdhan = notificationProvider.nextNotifcationAdhan;
    if (nextAdhan != null) {
      await _setAlarm(nextAdhan.startTime);
    }

    if (showNowIfPersistent && adhanDependency.showPersistant) {
      createNotification(forcedSilent: true, reschedule: false);
    }
  }
}

Future _setAlarm(DateTime date) async {
  await AndroidAlarmManager.initialize();
  await AndroidAlarmManager.cancel(0);
  await AndroidAlarmManager.oneShotAt(
    date,
    0,
    createNotification,
    allowWhileIdle: true,
    exact: true,
    wakeup: true,
    rescheduleOnReboot: true,
  );
}

Future cancelAllNotifications() async {
  final notifier = await _initializeNotifiers();
  await notifier.cancelAll();
}

Future createNotification({
  bool forcedSilent = false,
  bool reschedule = true,
}) async {

  final appLocale = engAppLocale;
  await initPreferences();
  final adhanDependency = AdhanDependencyProvider();

  final locationProvider = LocationProvider.getInstance();
  await locationProvider.init();

  final locationState = locationProvider.locationState;
  if (locationState is LocationAvailable) {
    final notificationProvider = AdhanNotificationProvider(
      adhanDependency,
      locationState.locationInfo,
      appLocale,
    );
    final currentAdhan = notificationProvider.currentAdhan;
    final nextAdhan = notificationProvider.nextAdhan;

    if (currentAdhan != null) {
      await _notifyAdhan(
          currentAdhan: currentAdhan,
          nextAdhan: nextAdhan,
          isPersistent: adhanDependency.showPersistant,
          notifyID:
              forcedSilent ? 0 : adhanDependency.notifyID(currentAdhan.type));

      if (currentAdhan.type == adhanTypeSunrise) {
        return scheduleNotification(preDefined: currentAdhan.endTime);
      }
    } else if (adhanDependency.showPersistant) {
      await _notifyAdhan(
        currentAdhan: null,
        nextAdhan: nextAdhan,
        isPersistent: true,
        notifyID: 0,
      );
    }
    if (reschedule) {
      await scheduleNotification();
    }
  }
}

NotificationDetails _createNotifyDetails({
  required int id,
  required String name,
  String? soundSource,
  String? uri,
  required bool isPersistent,
}) {
  assert(!(soundSource != null && uri != null));

  return NotificationDetails(
    android: AndroidNotificationDetails(
      id.toString(),
      name,
      channelDescription: 'Simple Adhan notifications - $name',
      sound: uri != null
          ? UriAndroidNotificationSound(uri)
          : soundSource != null
              ? RawResourceAndroidNotificationSound(soundSource)
              : null,
      playSound: soundSource != null || uri != null,
      onlyAlertOnce: id == 0,
      priority: Priority.max,
      ongoing: isPersistent,
      autoCancel: !isPersistent,
    ),
  );
}

Future<String?> getToneURI(int notifyID) => PlatformCall.getToneUri(notifyID);

Future<NotificationDetails> _getNotifyDetails(int id, bool isPersistant) async {
  switch (id) {
    case notifyIDAdhanNormal:
      return _createNotifyDetails(
        id: id,
        name: 'Normal',
        isPersistent: isPersistant,
      );
    case notifyIDAdhanAlarm:
      return _createNotifyDetails(
        id: id,
        name: 'Alarm',
        uri: sharedPrefAdhanAlarmUri.value,
        isPersistent: isPersistant,
      );
    case notifyIDAdhanRingtone:
      return _createNotifyDetails(
        id: id,
        name: 'Ringtone',
        uri: sharedPrefAdhanRingtoneUri.value,
        isPersistent: isPersistant,
      );
    case notifyIDAdhanMecca:
      return _createNotifyDetails(
        id: id,
        name: 'Mecca',
        soundSource: 'adhan_mecca',
        isPersistent: isPersistant,
      );
    case notifyIDAdhanMedina:
      return _createNotifyDetails(
        id: id,
        name: 'Medina',
        soundSource: 'adhan_medina',
        isPersistent: isPersistant,
      );
    default:
      return _createNotifyDetails(
        id: id,
        name: 'Silent',
        isPersistent: isPersistant,
      );
  }
}

/*
@Deprecated('Use _notifyUser Function Instead')
Future _notify(
  String title,
  String body, {
  required bool isPersistent,
  required int notifyID,
}) async {
  await (await _initializeNotifiers())
      .show(0, title, body, await _getNotifyDetails(notifyID, isPersistent));
}
*/

Future<void> _notifyAdhan({
  required Adhan? currentAdhan,
  required Adhan? nextAdhan,
  required bool isPersistent,
  required int notifyID,
}) async {
  try {
    String title = "Adhan";
    if (currentAdhan != null) {
      title =
          '${currentAdhan.title} (${currentAdhan.startTime.localizeTimeTo(engAppLocale)} -  ${currentAdhan.endTime.localizeTimeTo(engAppLocale)})';
    }

    String body = "";
    if (nextAdhan != null) {
      body =
          'Next: ${nextAdhan.title} (${nextAdhan.startTime.localizeTimeTo(engAppLocale)} -  ${nextAdhan.endTime.localizeTimeTo(engAppLocale)})';
    }

    //final success = await FlutterBackground.initialize(androidConfig: androidConfig);
/*    try {
      await initFlutterAndroidBackgroundService();
    } catch (e) {}*/

    final notifier = await _initializeNotifiers();
    await notifier.show(
      0,
      title,
      body,
      await _getNotifyDetails(notifyID, isPersistent),
    );

   /* if (isPersistent) {
      await notifier.cancelAll();
      if (await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        await FlutterForegroundTask.updateService(
          notificationTitle: title,
          notificationText: body,
        );
      } else {
        await FlutterForegroundTask.startService(
          notificationTitle: title,
          notificationText: body,
        );
      }
    } else {
      await FlutterForegroundTask.stopService();
    }*/
  } catch (e) {
    print(e);
  }
}
