import 'package:minimal_adhan/models/preference.dart';

Preference<double?> get sharedPrefLocationLatitude =>
    const Preference<double?>('loc_lat', null);

Preference<double?> get sharedPrefLocationLongitude =>
    const Preference<double?>('loc_long', null);

Preference<String?> get sharedPrefLocationAddress =>
    const Preference<String?>('loc_adr', null);

Preference<int> get sharedPrefAdhanMadhabIndex => const Preference('madhab', 0);

Preference<int> get sharedPrefCalcIndex => const Preference('calc', 0);

Preference<int> get sharedPrefAdhanHighLatRule => const Preference('hLat', 0);

List<Preference<bool>> get sharedPrefAdhanVisibility => const [
      Preference('vis_fajr', true),
      Preference('vis_sunrise', true),
      Preference('vis_dhuhr', true),
      Preference('vis_asr', true),
      Preference('vis_magrib', true),
      Preference('vis_isha', true),
      Preference('vis_midnight', true),
      Preference('vis_last_third', true)
    ];

List<Preference<int>> get sharedPrefAdhanManualCorrect => const [
      Preference('mCorrect_fajr', 0),
      Preference('mCorrect_sunrise', 0),
      Preference('mCorrect_dhuhr', 0),
      Preference('mCorrect_asr', 0),
      Preference('mCorrect_magrib', 0),
      Preference('mCorrect_isha', 0),
      Preference('mCorrect_midnight', 0),
      Preference('mCorrect_last_third', 0),
    ];

List<Preference<int>> get sharedPrefAdhanNotifyID => const [
      Preference('notify_id_mCorrect_fajr', 1),
      Preference('notify_id_mCorrect_sunrise', 1),
      Preference('notify_id_mCorrect_dhuhr', 1),
      Preference('notify_id_mCorrect_asr', 1),
      Preference('notify_id_mCorrect_magrib', 1),
      Preference('notify_id_mCorrect_isha', 1),
      Preference('notify_id_mCorrect_midnight', 0),
      Preference('notify_id_mCorrect_last_third', 0),
    ];

List<Preference<int>> get sharedPrefAdhanNotifyBefore => const [
      Preference('notify_before_fajr', 0),
      Preference('notify_before_sunrise', 0),
      Preference('notify_before_dhuhr', 0),
      Preference('notify_before_asr', 0),
      Preference('notify_before_magrib', 0),
      Preference('notify_before_isha', 0),
      Preference('notify_before_midnight', 0),
      Preference('notify_before_last_third', 0),
    ];

Preference<String> get sharedPrefAdhanCurrentLocalization =>
    const Preference('localization', 'en');

Preference<String> get sharedPrefDuaTranslationLang =>
    const Preference('dua_translate_lang', 'en');

Preference<bool> get sharedPrefDuaShowTranslation =>
    const Preference('dua_show_translate', true);

Preference<bool> get sharedPrefDuaSameAsPrimary =>
    const Preference('dua_sam_primary', true);

Preference<bool> get sharedPrefDuaShowTransliteration =>
    const Preference('dua_show_transliterate', true);

Preference<bool> get sharedPrefAdhanShowPersistentNotify =>
    const Preference('show_persistant_notify', false);

Preference<double> get sharedPrefDuaArabicFontSize =>
    const Preference('dua_arabic_size', 35.0);

Preference<double> get sharedPrefDuaOtherFontSize =>
    const Preference('dua_other_size', 15.0);

Preference<int> get sharedPrefAdhanThemeMode =>
    const Preference('adhan_theme', 0);

Preference<bool> get sharedPrefWelcomeShown =>
    const Preference('welcome_shown', false);

Preference<String?> get sharedPrefAdhanAlarmUri =>
    const Preference<String?>('alarm_uri', null);

Preference<String?> get sharedPrefAdhanRingtoneUri =>
    const Preference<String?>('ringtone_uri', null);

Preference<int?> get sharedPrefDatabaseVersion =>
    const Preference<int?>("db_ver", null);

Preference<bool> get sharedPrefAdhanNeverAskAgainForBatteryOptimization =>
    const Preference('nev_ask_bat_opt', false);

const KEY_TASBIH_LIST = 'tasbih_list';
const ADHAN_THEME_MODE_SYSTEM = 0;
const ADHAN_THEME_MODE_LIGHT = 1;
const ADHAN_THEME_MODE_DARK = 2;
