import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:minimal_adhan/helpers/sharedPrefHelper.dart';
import 'package:minimal_adhan/helpers/sharedprefKeys.dart';
import 'package:minimal_adhan/prviders/adhanPlayBackProvider.dart';
import 'package:minimal_adhan/prviders/adhanProvider.dart';
import 'package:minimal_adhan/prviders/ahdanNotificationProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import '../GPS_location_helper.dart';

const NOTIFY_ID_ADHAN_SILENT = 0;
const NOTIFY_ID_ADHAN_NORMAL = 1;
const NOTIFY_ID_ADHAN_ALARM = 2;
const NOTIFY_ID_ADHAN_RINGTONE = 3;
const NOTIFY_ID_ADHAN_MECCA = 4;
const NOTIFY_ID_ADHAN_MEDINA = 5;

void _validateNotifyPlatform() {
  //change as needed
  if (!Platform.isAndroid) {
    throw Exception(
        'Notification has not been set-up for ${Platform.operatingSystem}');
  }
}

Future<FlutterLocalNotificationsPlugin> _initializeNotifiers() async {
  //todo change progaurd rules for release builds (local_notifications)
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_notify');

  final InitializationSettings initializationSettings = InitializationSettings(
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
    print('Backing up uris');
    final alarmURI = await getToneURI(NOTIFY_ID_ADHAN_ALARM);
    final ringtoneURI = await getToneURI(NOTIFY_ID_ADHAN_RINGTONE);
    print('point');

    await setStringToSharedPref(KEY_ALARM_URI, alarmURI);
    await setStringToSharedPref(KEY_ALARM_URI, ringtoneURI);

    print('URI backed up : $alarmURI, $ringtoneURI');
  } catch (e) {}
}

Future<void> scheduleNotification(
    {DateTime? preDefined, bool showNowIfPersistent = false}) async {
  backupURIs();


  if (preDefined != null) {
    await _setAlarm(preDefined);
    return;
  }

  final adhanDependency = AdhanDependencyProvider();
  await adhanDependency.init();


  final locationState = adhanDependency.locationState;
  if (locationState is LocationAvailable) {
    final notificationProvider = AdhanNotificationProvider(
        adhanDependency, locationState.locationInfo, AppLocalizationsEn());
    final nextAdhan = notificationProvider.nextNotifcationAdhan;
    if (nextAdhan != null) {
      await _setAlarm(nextAdhan.startTime);
      print('schedule at ${nextAdhan.startTime}');
    }


    if (showNowIfPersistent && adhanDependency.showPersistant) {
      createNotification(forcedSilent: true, reschedule: false);
    }


  }
}

Future _setAlarm(DateTime date) async {
  await AndroidAlarmManager.initialize();
  await AndroidAlarmManager.cancel(0);
  await AndroidAlarmManager.oneShotAt(date, 0, createNotification,
      allowWhileIdle: true,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true);
}

Future cancelAllNotifications() async {
  final notifier = await _initializeNotifiers();
  await notifier.cancelAll();
}

void createNotification(
    {bool forcedSilent = false, bool reschedule = true}) async {
  await initializeDateFormatting('en');

  final adhanDependency = AdhanDependencyProvider();
  await adhanDependency.init();
  final locationState = adhanDependency.locationState;
  if (locationState is LocationAvailable) {
    final notificationProvider = AdhanNotificationProvider(
        adhanDependency, locationState.locationInfo, AppLocalizationsEn());
    final currentAdhan = notificationProvider.currentAdhan;

    if (currentAdhan != null) {
      await _notify(currentAdhan.title,
          '${currentAdhan.formattedStartTime} -  ${currentAdhan.formattedEndTime}',
          isPersistent: adhanDependency.showPersistant,
          notifyID:
              forcedSilent ? 0 : adhanDependency.notifyID(currentAdhan.type));

      if (currentAdhan.type == ADHAN_TYPE_SUNRISE) {
        return scheduleNotification(preDefined: currentAdhan.endTime);
      }
    } else if (adhanDependency.showPersistant) {
      await _notify('Adhan', 'So remember me, I will remember you - Quran',
          isPersistent: true, notifyID: 0);
    }
    if (reschedule) {
      await scheduleNotification();
    }
  }
}

NotificationDetails _createNotifyDetails(
    {required int id,
    required String name,
    String? soundSource,
    String? uri,
    required bool isPersistant}) {
  assert(!(soundSource != null && uri != null));

  print('$soundSource, $uri, $id');
  return NotificationDetails(
      android: AndroidNotificationDetails(id.toString(), name,
          channelDescription: 'Simple Adhan notifications - $name',
          sound: uri != null
              ? UriAndroidNotificationSound(uri)
              : soundSource != null
                  ? RawResourceAndroidNotificationSound(soundSource)
                  : null,
          playSound: soundSource != null || uri != null,
          onlyAlertOnce: id == 0,
          priority: Priority.max,
          ongoing: isPersistant,
          autoCancel: !isPersistant));
}

Future<String> getToneURI(int notifyID) async {
  if (Platform.isAndroid) {
    return await methodChannel.invokeMethod('getToneURI', notifyID);
  } else {
    throw Exception('Alarm URI not setup for ${Platform.operatingSystem}');
  }
}

Future<NotificationDetails> _getNotifyDetails(int id, bool isPersistant) async {
  switch (id) {
    case NOTIFY_ID_ADHAN_NORMAL:
      return _createNotifyDetails(
          id: id, name: 'Normal', isPersistant: isPersistant);
    case NOTIFY_ID_ADHAN_ALARM:
      return _createNotifyDetails(
          id: id,
          name: 'Alarm',
          uri: await getStringFromSharedPref(KEY_ALARM_URI),
          isPersistant: isPersistant);
    case NOTIFY_ID_ADHAN_RINGTONE:
      return _createNotifyDetails(
          id: id,
          name: 'Ringtone',
          uri: await getStringFromSharedPref(KEY_RINGTONE_URI),
          isPersistant: isPersistant);
    case NOTIFY_ID_ADHAN_MECCA:
      return _createNotifyDetails(
          id: id,
          name: 'Mecca',
          soundSource: 'adhan_mecca',
          isPersistant: isPersistant);
    case NOTIFY_ID_ADHAN_MEDINA:
      return _createNotifyDetails(
          id: id,
          name: 'Medina',
          soundSource: 'adhan_medina',
          isPersistant: isPersistant);
    default:
      return _createNotifyDetails(
          id: id, name: 'Silent', isPersistant: isPersistant);
  }
}

Future testNotification() async {
  final notifier = await _initializeNotifiers();
  await notifier.show(
      1, "Test Notification", "Testing", await _getNotifyDetails(1, false));
}

Future _notify(String title, String body,
    {required bool isPersistent, required int notifyID}) async {
  _validateNotifyPlatform();
  await (await _initializeNotifiers())
      .show(0, title, body, await _getNotifyDetails(notifyID, isPersistent));
}
