import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/helpers/gps_location_helper.dart';
import 'package:minimal_adhan/helpers/preferences.dart';
import 'package:minimal_adhan/platform_dependents/method_channel_helper.dart';
import 'package:minimal_adhan/prviders/adhanProvider.dart';
import 'package:minimal_adhan/prviders/ahdanNotificationProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/prviders/locationProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const notifyAdhanIdSilent = 0;
const notifyIDAdhanNormal = 1;
const notifyIDAdhanAlarm = 2;
const notifyIDAdhanRingtone = 3;
const notifyIDAdhanMecca = 4;
const notifyIDAdhanMedina = 5;

void _validateNotifyPlatform() {
  //change as needed
  if (!Platform.isAndroid) {
    throw Exception(
      'Notification has not been set-up for ${Platform.operatingSystem}',
    );
  }
}

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

    await alarmURI?.let((it) async => sharedPrefAdhanAlarmUri.value = it);
    await ringtoneURI?.let((it) async => sharedPrefAdhanAlarmUri.value = it);
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

  final pref = await SharedPreferences.getInstance();
  final adhanDependency = AdhanDependencyProvider(pref);

  final locationProvider = LocationProvider(pref);
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
  await initializeDateFormatting('en');
  final pref = await SharedPreferences.getInstance();
  final adhanDependency = AdhanDependencyProvider(pref);

  final locationProvider = LocationProvider(pref);
  await locationProvider.init();

  final locationState = locationProvider.locationState;
  if (locationState is LocationAvailable) {
    final notificationProvider = AdhanNotificationProvider(
      adhanDependency,
      locationState.locationInfo,
      engAppLocale,
    );
    final currentAdhan = notificationProvider.currentAdhan;

    if (currentAdhan != null) {
      await _notify(
        currentAdhan.title,
        '${currentAdhan.formattedStartTime} -  ${currentAdhan.formattedEndTime}',
        isPersistent: adhanDependency.showPersistant,
        notifyID:
            forcedSilent ? 0 : adhanDependency.notifyID(currentAdhan.type),
      );

      if (currentAdhan.type == adhanTypeSunrise) {
        return scheduleNotification(preDefined: currentAdhan.endTime);
      }
    } else if (adhanDependency.showPersistant) {
      await _notify(
        'Adhan',
        'So remember me, I will remember you - Quran',
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

Future testNotification() async {
  final notifier = await _initializeNotifiers();
  await notifier.show(
    1,
    "Test Notification",
    "Testing",
    await _getNotifyDetails(1, false),
  );
}

Future _notify(
  String title,
  String body, {
  required bool isPersistent,
  required int notifyID,
}) async {
  _validateNotifyPlatform();
  await (await _initializeNotifiers())
      .show(0, title, body, await _getNotifyDetails(notifyID, isPersistent));
}
