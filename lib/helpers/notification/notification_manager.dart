/*
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:minimal_adhan/helpers/GPS_location_helper.dart';
import 'package:minimal_adhan/prviders/adhanProvider.dart';
import 'package:minimal_adhan/prviders/ahdanNotificationProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';

NotificationChannel _createChannel(int channelKey, String type,
    {DefaultRingtoneType? defaultRingtoneType, String? soundSource}) {
  assert(!(soundSource != null && defaultRingtoneType != null));

  return NotificationChannel(
      channelKey: channelKey.toString(),
      channelName: channelKey.toString(),
      channelDescription: 'Simple Adhan notifications - $type',
      defaultColor: Colors.green,
      ledColor: Colors.white,
      importance: NotificationImportance.Max,
      defaultRingtoneType: defaultRingtoneType,
      playSound: soundSource != null || defaultRingtoneType != null,
      soundSource: soundSource,
      onlyAlertOnce: channelKey == 0);
}

Future initializeNotifiers() async {
  await AwesomeNotifications().initialize(
      null,
      [
        _createChannel(0, 'Silent'),
        _createChannel(1, 'Normal'),
        _createChannel(2, 'Alarm',
            defaultRingtoneType: DefaultRingtoneType.Alarm),
        _createChannel(3, 'Ringtone',
            defaultRingtoneType: DefaultRingtoneType.Ringtone),
        _createChannel(4, 'Mecca', soundSource: 'resource://raw/adhan_mecca'),
        _createChannel(5, 'Medina',
            soundSource: 'resource://raw/adhan_medina'),
      ]);

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
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

Future scheduleNotification(
    {DateTime? preDefined, bool showNowIfPersistent = false}) async {

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
      await notify(currentAdhan.title,
          '${currentAdhan.formattedStartTime} -  ${currentAdhan.formattedEndTime} with notify ${adhanDependency.notifyID(currentAdhan.type)}',
          isPersistent: adhanDependency.showPersistant,
          notifyID:
              forcedSilent ? 0 : adhanDependency.notifyID(currentAdhan.type));

      if (currentAdhan.type == ADHAN_TYPE_SUNRISE) {
        return scheduleNotification(preDefined: currentAdhan.endTime);
      }
    } else if (adhanDependency.showPersistant) {
      await notify('Adhan', 'So remember me, I will remember you - Quran',
          isPersistent: true, notifyID: 0);
    }
    if (reschedule) {
      await scheduleNotification();
    }
  }
}

void cancelAllNotifications() {
  AwesomeNotifications().cancel(0);
}

Future notify(String title, String body,
    {required bool isPersistent, required int notifyID}) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 0,
          channelKey: notifyID.toString(),
          title: title,
          body: body,
          locked: isPersistent,
          autoCancel: false));
}
*/
