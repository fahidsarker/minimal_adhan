import 'package:flutter/cupertino.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/models/preference.dart';

abstract class DependencyProvider with ChangeNotifier {
  @inline
  void updateDataByRunning(Future Function() clbk) {
    clbk().then((value) => notifyListeners());
  }

  @inline
  void updateDataWithPreference<T extends Object>(Preference<T> pref, T value) {
    pref.updateValue(value).then((value) => notifyListeners());
  }
}
