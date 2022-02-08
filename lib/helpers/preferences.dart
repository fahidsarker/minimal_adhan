import 'package:minimal_adhan/models/preference.dart';

DoublePreference get sharedPrefLocationLatitude =>
    const DoublePreference('loc_lat', null);

DoublePreference get sharedPrefLocationLongitude =>
    const DoublePreference('loc_long', null);

StringPreference<String?> get sharedPrefLocationAddress =>
    const StringPreference<String?>('loc_adr', null);

IntPreference<int> get sharedPrefAdhanMadhabIndex => const IntPreference('madhab', 0);
IntPreference<int> get sharedPrefCalcIndex => const IntPreference('calc', 0);
IntPreference<int> get sharedPrefAdhanHighLatRule => const IntPreference('hLat', 0);

List<BoolPreference> get sharedPrefAdhanVisibility => const [
      BoolPreference('vis_fajr', true),
      BoolPreference('vis_sunrise', true),
      BoolPreference('vis_dhuhr', true),
      BoolPreference('vis_asr', true),
      BoolPreference('vis_magrib', true),
      BoolPreference('vis_isha', true),
      BoolPreference('vis_midnight', true),
      BoolPreference('vis_last_third', true)
    ];

List<IntPreference<int>> get sharedPrefAdhanManualCorrect => const [
      IntPreference('mCorrect_fajr', 0),
      IntPreference('mCorrect_sunrise', 0),
      IntPreference('mCorrect_dhuhr', 0),
      IntPreference('mCorrect_asr', 0),
      IntPreference('mCorrect_magrib', 0),
      IntPreference('mCorrect_isha', 0),
      IntPreference('mCorrect_midnight', 0),
      IntPreference('mCorrect_last_third', 0),
    ];

List<IntPreference<int>> get sharedPrefAdhanNotifyID => const [
      IntPreference('notify_id_mCorrect_fajr', 1),
      IntPreference('notify_id_mCorrect_sunrise', 1),
      IntPreference('notify_id_mCorrect_dhuhr', 1),
      IntPreference('notify_id_mCorrect_asr', 1),
      IntPreference('notify_id_mCorrect_magrib', 1),
      IntPreference('notify_id_mCorrect_isha', 1),
      IntPreference('notify_id_mCorrect_midnight', 0),
      IntPreference('notify_id_mCorrect_last_third', 0),
    ];

List<IntPreference<int>> get sharedPrefAdhanNotifyBefore => const [
      IntPreference('notify_before_fajr', 0),
      IntPreference('notify_before_sunrise', 0),
      IntPreference('notify_before_dhuhr', 0),
      IntPreference('notify_before_asr', 0),
      IntPreference('notify_before_magrib', 0),
      IntPreference('notify_before_isha', 0),
      IntPreference('notify_before_midnight', 0),
      IntPreference('notify_before_last_third', 0),
    ];

StringPreference<String> get sharedPrefAdhanCurrentLocalization =>
    const StringPreference('localization', 'en');

StringPreference<String> get sharedPrefDuaTranslationLang =>
    const StringPreference('dua_translate_lang', 'en');

BoolPreference get sharedPrefDuaShowTranslation =>
    const BoolPreference('dua_show_translate', true);

BoolPreference get sharedPrefDuaSameAsPrimary =>
    const BoolPreference('dua_sam_primary', true);

BoolPreference get sharedPrefDuaShowTransliteration =>
    const BoolPreference('dua_show_transliterate', true);

BoolPreference get sharedPrefAdhanShowPersistentNotify =>
    const BoolPreference('show_persistant_notify', false);

DoublePreference<double> get sharedPrefDuaArabicFontSize =>
    const DoublePreference('dua_arabic_size', 35.0);

DoublePreference<double> get sharedPrefDuaOtherFontSize =>
    const DoublePreference('dua_other_size', 15.0);

IntPreference<int> get sharedPrefAdhanThemeMode =>
    const IntPreference('adhan_theme', 0);

BoolPreference get sharedPrefWelcomeShown =>
    const BoolPreference('welcome_shown', false);

StringPreference get sharedPrefAdhanAlarmUri =>
    const StringPreference<String?>('alarm_uri', null);

StringPreference get sharedPrefAdhanRingtoneUri =>
    const StringPreference<String?>('ringtone_uri', null);

IntPreference get sharedPrefDatabaseVersion =>
    const IntPreference("db_ver", null);

BoolPreference get sharedPrefAdhanNeverAskAgainForBatteryOptimization =>
    const BoolPreference('nev_ask_bat_opt', false);

const KEY_TASBIH_LIST = 'tasbih_list';
const ADHAN_THEME_MODE_SYSTEM = 0;
const ADHAN_THEME_MODE_LIGHT = 1;
const ADHAN_THEME_MODE_DARK = 2;
