import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void notificationBackgroundDispatcher() {
  const MethodChannel _backgroundChannel = MethodChannel('notification_dispatcher');
  WidgetsFlutterBinding.ensureInitialized();

  _backgroundChannel.setMethodCallHandler((MethodCall call) async {
    final List<dynamic> args = call.arguments;
    final Function? callbackThis = PluginUtilities.getCallbackFromHandle(
        CallbackHandle.fromRawHandle(args[0]));
    if(callbackThis == null)
      return;
    String s = args[1] as String;
    callbackThis(s);
  });
}