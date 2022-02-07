import 'package:flutter/cupertino.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/models/preference.dart';

abstract class DependencyProvider with ChangeNotifier{

  @inline
  void updateDataByRunning (void Function() clbk){
    clbk();
    notifyListeners();
  }

  @inline
  void updateDataWithPreference<T extends Object>(Preference<T> pref, T value){
    pref.value = value;
    notifyListeners();
  }
}
