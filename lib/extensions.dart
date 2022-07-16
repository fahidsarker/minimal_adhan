import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hijri/hijri_calendar.dart';

late AppLocalizationsEn  engAppLocale = AppLocalizationsEn();


const inline = pragma('@vm:prefer-inline');



const Iterable<LocalizationsDelegate> appLocaleDelegates = [
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

extension ObjHelper<T extends Object> on T {
  @inline
  Future let(void Function(T) clbk) async {
    clbk(this);
  }
}

extension FuncHelper<T, R> on T Function(R) {
  void tryCatch(R v, {required void Function(T ret) tryTo}) {
    try {
      tryTo(this(v));
    } catch (_) {}
  }
}

extension WidgetHelper on Widget {
  Widget showBoundaries([Color color = Colors.red]){
    return ClipRect(
      child: BackdropFilter(
        filter:  ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: color,
          child: this,
        ),
      ),
    );
  }
}

extension LstHelper<T extends Object> on List<T?> {
  Future let(void Function(List<T>) clbk) async {
    bool okay = false;
    final List<T> trf = [];
    for (final element in this) {
      if (element == null) {
        okay = false;
        break;
      } else {
        trf.add(element);
      }
    }
    if (okay) {
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
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(txt),
      ),
    );
  }

  bool get isDarkMode {
    return theme.scaffoldBackgroundColor != Colors.white;
  }
}

extension DoubleHelper<T extends num> on double {
  T closestTo(List<T> values) {
    T lastMin = values[0];
    double lastDif = (lastMin - this).abs();

    if (values.length == 1) {
      return lastMin;
    }

    for (int i = 1; i < values.length; i++) {
      final tempDiff = (values[i] - this).abs();
      if (tempDiff < lastDif) {
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

  String getHeadingName(double heading) {
    return (heading >= 0 && heading < 45)
        ? compass_heading_north
        : (heading >= 45 && heading < 90)
            ? compass_heading_north_east
            : (heading >= 90 && heading < 135)
                ? compass_heading_east
                : (heading >= 135 && heading < 180)
                    ? compass_heading_south_east
                    : (heading >= 180 && heading < 225)
                        ? compass_heading_south
                        : (heading >= 225 && heading < 270)
                            ? compass_heading_south_west
                            : (heading >= 270 && heading < 315)
                                ? compass_heading_west
                                : (heading >= 315 && heading < 360)
                                    ? compass_heading_north_west
                                    : compass_heading_north;
  }

  String getDigitFor(int i){
    assert(i >= 0 && i <= 9, "the digit must be between 0 and 9");
    return [
      zero, one,two, three, four, five, six, seven, eight, nine
    ][i];
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

  bool get isLargeScreen{
    return width >= 600;
  }

  double get panelWidth {
    return isLargeScreen ? 400 : width;
  }

  double get minPanelSize{
    final minSize = min(width, height);
    return minSize - (isLargeScreen ? 100 : 0);
  }

  double get contentPanelRatio{
    return isLargeScreen ? 0.6 : 1.0;
  }

  double get contentPanelWidth{
    return isLargeScreen ? width * contentPanelRatio : width;
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

    return year == today.year && month == today.month && day == today.day;
  }

  bool get isJummahToday {
    return weekday == 5;
  }

  String getHizriDateForLocale(AppLocalizations locale, {String separator = '-'}){
    final months = [
      locale.arabic_month_muharram,
      locale.arabic_month_safar,
      locale.arabic_month_rabi_al_awwal,
      locale.arabic_month_rabi_al_thani,
      locale.arabic_month_jumada_al_awwal,
      locale.arabic_month_jumada_al_thani,
      locale.arabic_month_rajab,
      locale.arabic_month_shaban,
      locale.arabic_month_ramadan,
      locale.arabic_month_shawwal,
      locale.arabic_month_dhu_al_qadha,
      locale.arabic_month_dhu_al_hijjah];

    final hDate = HijriCalendar.fromDate(this);
    return '${hDate.hDay.localizeTo(locale)}$separator${months[hDate.hMonth-1]}$separator${hDate.hYear.localizeTo(locale)}';
  }

  String localizeTimeTo (AppLocalizations locale){
    int hr = hour;
    bool isPM = false;
    if(hr > 12){
      hr -= 12;
      isPM = true;
    }
    final digitHr = hr.toString().length;
    final digitMin = minute.toString().length;

    return '${digitHr == 1 ? '0' : ''}$hr:${digitMin == 1 ? '0' : ''}$minute ${isPM ? locale.pm : locale.am}'.localizeDigitsOnly(locale);

  }

}

extension StringHelper on String {
  String localizeDigitsOnly(AppLocalizations locale){
    var localized = '';
    for(int i = 0; i < length; i++){

      final char = this[i];
      final val = int.tryParse(char);

      if(val == null){
        localized += char;
      }else{
        final localizedDigit = locale.getDigitFor(val);
        localized += localizedDigit;
      }
    }

    if(locale.numeric_direction == 'rlt'){
      localized = localized.split('').reversed.join();
    }

    return localized;
  }
}

extension IntHelper on int{
  String localizeTo(AppLocalizations locale){
    final strNum = toString();
    var localized = '';
    for(int i = 0; i < strNum.length; i++){
      final digit = strNum[i];
      final localizedDigit = locale.getDigitFor(digit.toInt());
      localized += localizedDigit;
    }

    if(locale.numeric_direction == 'rlt'){
      localized = localized.split('').reversed.join();
    }

    return localized;
  }
}