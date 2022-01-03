import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
const methodChannel = MethodChannel("com.fsapps.minimaladhan");

class AdhanPlayBackProvider with ChangeNotifier {
  int playing = -1;

  void playBack(int notifyID) async {
    final res = playing == notifyID ? await stop() : await play(notifyID);
    playing = res;
    notifyListeners();
  }

  Future<int> play(int notifyID) async {
    if (Platform.isAndroid) {
      return await methodChannel.invokeMethod('play', notifyID);
    } else {
      throw UnimplementedError('Not implemented');
    }
  }


  @override
  void dispose() {
    stop();
    super.dispose();
  }

  Future<int> stop() async {
    if (Platform.isAndroid) {
      return await methodChannel.invokeMethod('stop');
    } else {
      throw UnimplementedError('Not implemented');
    }
  }
}
