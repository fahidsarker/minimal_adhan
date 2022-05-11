import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

AppLocalizationsEn get engAppLocale {
  return AppLocalizationsEn();
}

const inline = pragma('@vm:prefer-inline');


const Iterable<LocalizationsDelegate> appLocaleDelegates =  [
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];


extension ObjHelper<T extends Object> on T{
  @inline
  Future let (void Function(T) clbk) async{
    clbk(this);
  }
}



extension FuncHelper<T,R> on T Function(R) {
  void tryCatch (R v, {required void Function(T ret) tryTo}){
    try{
      tryTo(this(v));
    }catch(_){

    }
  }
}


extension LstHelper <T extends Object> on List<T?>{

  Future let (void Function(List<T>) clbk) async{
    bool okay = false;
    final List<T> trf = [];
    for(final element in this) {
      if(element == null){
        okay = false;
        break;
      }else{
        trf.add(element);
      }
    }
    if(okay){
      clbk(trf);
    }
  }
}

extension ContextHelper on BuildContext {
  void push(Widget child) {
    Navigator.push(this, MaterialPageRoute(builder: (_) => child));
  }

  void pop<T extends Object>([T? res]) {
    Navigator.pop(this, res);
  }

  void showSnackBar(String txt) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(txt),
    ),);
  }

  bool get isDarkMode{
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }

}

extension IntHelper<T extends num> on double{
  T closestTo (List<T> values){
    T lastMin = values[0];
    double lastDif = (lastMin - this).abs();

    if(values.length == 1){
      return lastMin;
    }

    for(int i= 1; i<values.length; i++){
      final tempDiff = (values[i] - this).abs();
      if(tempDiff < lastDif){
        lastDif = tempDiff;
        lastMin = values[1];
      }
    }

    return lastMin;

  }
}

extension LocalizeHelper on AppLocalizations {
  String getAdhanName(int i, {bool isJummah = false}) {
    return [
      adhan_fajr,
      adhan_sunrise,
      if (isJummah) '$adhan_jummah - $adhan_dhuhr' else adhan_dhuhr,
      adhan_asr,
      adhan_magrib,
      adhan_isha,
      adhan_midnight,
      adhan_third_night
    ][i];
  }

  List<String> get themeModes {
    return [follow_system, always_light, always_dark];
  }
}

extension Helper on BuildContext {
  Color get primaryColor {
    return theme.colorScheme.primary;
  }

  Color get secondaryColor {
    return theme.colorScheme.secondary;
  }

  Color get darkPrimary {
    return Theme.of(this).primaryColorDark;
  }

  double get height {
    return MediaQuery.of(this).size.height;
  }

  double get width {
    return MediaQuery.of(this).size.width;
  }

  TextTheme get textTheme {
    return Theme.of(this).textTheme;
  }

  ThemeData get theme {
    return Theme.of(this);
  }

  double get smallerBetweenHeightAndWidth {
    return min(width, height);
  }

  AppLocalizations get appLocale {
    return AppLocalizations.of(this)!;
  }
}


extension BoolParsing on String {
  bool toBool() {
    return toLowerCase() == 'true';
  }
  int toInt() => int.parse(this);
}

extension DateHelper on DateTime {

  int daysFrom(DateTime to) {
    final from = DateTime(year, month, day);
    final nto = DateTime(to.year, to.month, to.day);
    return (nto.difference(from).inHours / 24).round();
  }

  bool get isToday {
    final today = DateTime.now();

    return year == today.year &&
        month == today.month &&
        day == today.day;
  }

  bool get isJummahToday {
    return weekday == 5;
  }


}
