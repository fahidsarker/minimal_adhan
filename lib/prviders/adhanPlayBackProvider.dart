import 'package:flutter/cupertino.dart';
import 'package:minimal_adhan/platform_dependents/method_channel_helper.dart';

class AdhanPlayBackProvider with ChangeNotifier {
  int playing = -1;

  Future playBack(int notifyID) async {
    final res = playing == notifyID ? await stop() : await play(notifyID);
    playing = res ?? -1;
    notifyListeners();
  }

  Future<int?> play(int notifyID) => PlatformCall.startNotificationPlayback(notifyID);


  @override
  void dispose() {
    stop();
    super.dispose();
  }

  Future<int?> stop() => PlatformCall.stopNotificationPlayback();

}
