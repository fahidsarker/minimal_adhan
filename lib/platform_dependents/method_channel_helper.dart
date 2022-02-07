import 'dart:io';

import 'package:flutter/services.dart';

const _methodChannel = MethodChannel("azan_method_call");

class PlatformCall {

  ///Currently implemented on [Platform.isAndroid] only
  ///invokes method on channel [_methodChannel]
  static Future<T?> _invokeMethod<T>(String method, [ dynamic arguments ]) async{
    if (Platform.isAndroid) { // setup os as needed
      return _methodChannel.invokeMethod(method, arguments);
    } else {
      throw UnimplementedError('$method not implemented for ${Platform.operatingSystem}');
    }
  }
  

  /// plays the notification tone
  /// Implemented on the platform code
  /// returns [notifyID] if success
  static Future<int?> startNotificationPlayback(int notifyID) => _invokeMethod('play', notifyID);

  /// stops the notification tone
  /// Implemented on the platform code
  /// returns [notifyID] if success
  static Future<int?> stopNotificationPlayback () => _invokeMethod('stop');

  ///opens app store
  static void openAppStore () => _invokeMethod('openPlayStore');

  ///fetches tone uri (Ringtone and alarm tone) from
  ///platform
  static Future<String?> getToneUri (int notifyID) => _invokeMethod('getToneURI', notifyID);

  PlatformCall._();
}
