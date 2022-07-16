import 'dart:io';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';


Future<void> initFlutterAndroidBackgroundService() async{
  await FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'notification_channel_id_4',
      channelName: 'Foreground Notification',
      channelDescription: 'This notification appears when the foreground service is running.',
      channelImportance: NotificationChannelImportance.NONE,
      priority: NotificationPriority.LOW,
      iconData: const NotificationIconData(
        resType: ResourceType.drawable,
        resPrefix: ResourcePrefix.ic,
        name: 'notify_active',
      ),
      buttons: [

      ],
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: true,
      playSound: false,
    ),
    printDevLog: true,
  );
}
