import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/helpers/gps_location_helper.dart';
import 'package:minimal_adhan/localizations/locales.dart';
import 'package:minimal_adhan/platform_dependents/method_channel_helper.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/DuaDependencyProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/GlobalDependencyProvider.dart';
import 'package:minimal_adhan/prviders/locationProvider.dart';
import 'package:minimal_adhan/screens/feedback/form_links.dart';
import 'package:minimal_adhan/screens/settings/bottomsheets/AppLanguagePicker.dart';
import 'package:minimal_adhan/screens/settings/bottomsheets/CalcMehtodChooser.dart';
import 'package:minimal_adhan/screens/settings/bottomsheets/DuaTranslationLangPicker.dart';
import 'package:minimal_adhan/screens/settings/bottomsheets/highLatRuleChooser.dart';
import 'package:minimal_adhan/screens/settings/bottomsheets/madhabChooser.dart';
import 'package:minimal_adhan/screens/settings/bottomsheets/themePicker.dart';
import 'package:minimal_adhan/screens/settings/screens/adhan_visibility_screen.dart';
import 'package:minimal_adhan/screens/settings/screens/manual_correction_screen.dart';
import 'package:minimal_adhan/screens/settings/widgets/SettingsTile.dart';
import 'package:minimal_adhan/screens/settings/widgets/fontsizeSelectorDialog.dart';
import 'package:minimal_adhan/screens/settings/widgets/settingsSection.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

const bottomSheetShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topRight: Radius.circular(20),
    topLeft: Radius.circular(20),
  ),
);

void buildBottomSheet(Widget content, BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    context: context,
    builder: (_) => content,
    shape: bottomSheetShape,
  );
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final globalProvider = context.watch<GlobalDependencyProvider>();
    final appLocale = context.appLocale;
    final adhanDependency = context.watch<AdhanDependencyProvider>();
    final duaDependency = context.watch<DuaDependencyProvider>();
    final locationProvider = context.watch<LocationProvider>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          appLocale.settings,
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          SettingsSection(
            title: appLocale.global,
            tiles: [
              if (globalProvider.needToShowDiableBatteryOptimizeDialog)
                SettingsClickable(
                  onClick: () {
                    globalProvider.disableBatteryOptimization();
                  },
                  title: appLocale.disable_battery_optimization,
                  subtitle: appLocale.disable_battery_optimization_desc,
                  leading: const Icon(Icons.warning),
                ),
              SettingsClickable(
                onClick: () => buildBottomSheet(
                  ChangeNotifierProvider.value(
                    value: duaDependency,
                    child: AppLanguagePicker(),
                  ),
                  context,
                ),
                title: appLocale.language,
                subtitle: appLocale.current_lang,
                leading: Icon(
                  Icons.language,
                  color: context.primaryColor,
                ),
              ),
              SettingsClickable(
                onClick: () => buildBottomSheet(const ThemePicker(), context),
                title: appLocale.theme,
                subtitle: globalProvider.getThemeModeText(appLocale),
                leading: Icon(
                  Icons.style,
                  color: context.primaryColor,
                ),
              ),
              SettingsClickable(
                onClick: () =>
                    locationProvider.updateLocationWithGPS(background: false),
                title: appLocale.location,
                leading: Icon(
                  Icons.my_location,
                  color: context.primaryColor,
                ),
                subtitle:
                    '${locationProvider.locationState is LocationAvailable ? (locationProvider.locationState as LocationAvailable).locationInfo.address : locationProvider.locationState is LocationFinding ? appLocale.finding : appLocale.error_occured}\n${appLocale.tap_to_update}',
              ),
            ],
          ),
          SettingsSection(
            title: appLocale.adhan,
            tiles: [
              SettingsClickable(
                onClick: () => buildBottomSheet(CalcMethodChooser(), context),
                title: appLocale.calc_method,
                subtitle: adhanDependency.paranName,
                leading: Icon(
                  Icons.calculate,
                  color: context.primaryColor,
                ),
              ),
              SettingsClickable(
                onClick: () => buildBottomSheet(const MadhabChooser(), context),
                title: appLocale.madhab,
                subtitle: [
                  appLocale.hanafi_madhab,
                  appLocale.shafi_madhab
                ][adhanDependency.madhabIndex],
                leading: Icon(
                  Icons.school,
                  color: context.primaryColor,
                ),
              ),
              SettingsClickable(
                onClick: () =>
                    buildBottomSheet(const HighLatRuleChooser(), context),
                title: appLocale.high_lat_rule,
                subtitle: adhanDependency.highLatRuleName,
                leading: Icon(
                  Icons.height,
                  color: context.primaryColor,
                ),
              ),
              SettingsClickable(
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdhanVisibilityScreen(),
                    ),
                  );
                },
                title: appLocale.adhan_visibility,
                leading: Icon(
                  Icons.visibility,
                  color: context.primaryColor,
                ),
              ),
              SettingsClickable(
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ManualCorrectionScreen(),
                    ),
                  );
                },
                title: appLocale.adhan_manual_correction,
                subtitle: adhanDependency.manualCorrectionAll,
                leading: Icon(
                  Icons.timer_outlined,
                  color: context.primaryColor,
                ),
              ),
              SettingsToggle(
                onToggle: (val) async {
                  adhanDependency.changePersistantNotifyStatus(newVal: val);
                },
                subtitle: appLocale.persistent_notify_desc,
                title: appLocale.persistent_notify,
                value: adhanDependency.showPersistant,
                leading: Icon(
                  Icons.notifications_rounded,
                  color: context.primaryColor,
                ),
              ),
              // SettingsToggle(onToggle: (){}, title: 'View Jummah', value: )
            ],
          ),
          SettingsSection(
            title: appLocale.dua,
            tiles: [
              SettingsToggle(
                onToggle: (v) =>
                    duaDependency.changeShowTransliteration(newValue: v),
                title: appLocale.show_transliteration,
                value: duaDependency.showTransliteration,
                leading: Icon(
                  Icons.text_snippet,
                  color: context.primaryColor,
                ),
              ),
              SettingsToggle(
                onToggle: (v) =>
                    duaDependency.changeShowTranslation(newValue: v),
                title: appLocale.show_translation,
                value: duaDependency.showTranslation,
                leading: Icon(
                  Icons.translate,
                  color: context.primaryColor,
                ),
              ),
              if (duaDependency.showTranslation)
                SettingsClickable(
                  onClick: () => buildBottomSheet(
                    ChangeNotifierProvider.value(
                      value: duaDependency,
                      child: DuaTranslationLangPicker(),
                    ),
                    context,
                  ),
                  title: appLocale.translation_lang,
                  subtitle: duaDependency.sameAsPrimaryLang
                      ? appLocale.primary_language
                      : supportedLocales
                          .firstWhere(
                            (element) =>
                                element.languageCode ==
                                duaDependency.translationLang,
                          )
                          .languageName,
                  leading: Icon(
                    Icons.language,
                    color: context.primaryColor,
                  ),
                ),
              SettingsClickable(
                onClick: () => showDialog(
                  context: context,
                  builder: (_) => const FontSizeSelector(
                    arabic: true,
                  ),
                ),
                title: appLocale.arabic_font_size,
                subtitle:
                    '${duaDependency.arabicFontSize.toStringAsFixed(2)} px',
                leading: Icon(
                  Icons.format_size,
                  color: context.primaryColor,
                ),
              ),
              SettingsClickable(
                onClick: () => showDialog(
                  context: context,
                  builder: (_) => const FontSizeSelector(
                    arabic: false,
                  ),
                ),
                title: appLocale.other_font_size,
                subtitle:
                    '${duaDependency.otherFontSize.toStringAsFixed(2)} px',
                leading: Icon(
                  Icons.format_size,
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          SettingsSection(
            title: appLocale.support_dev,
            tiles: [
              SettingsClickable(
                onClick: () => PlatformCall.openAppStore(),
                title: appLocale.rate_on_play_store,
                subtitle: appLocale.rate_on_play_store_desc,
                leading: Icon(
                  Icons.star_rate_sharp,
                  color: context.primaryColor,
                ),
              ),
/*              SettingsClickable(
                onClick: () {},
                title: appLocale.help_us_translate,
                subtitle: appLocale.help_us_translate_desc,
                leading: Icon(Icons.translate),
              ),*/
              SettingsClickable(
                onClick: () => launchUrl(
                  Uri.parse(githubRepoLink),
                  mode: LaunchMode.externalApplication,
                ),
                title: appLocale.github_ripo,
                subtitle: appLocale.github_ripo_desc,
                leading: Icon(
                  Icons.code,
                  color: context.primaryColor,
                ),
              ),
              SettingsClickable(
                onClick: () => launchUrl(Uri.parse(getBugReportForm())),
                title: appLocale.report_bug,
                subtitle: appLocale.report_bug_desc,
                leading: Icon(
                  Icons.bug_report,
                  color: context.primaryColor,
                ),
              ),
              SettingsClickable(
                onClick: () => launchUrl(Uri.parse(getFeatureRequestForm())),
                title: appLocale.request_a_feature,
                subtitle: appLocale.request_a_feature_desc,
                leading: Icon(
                  Icons.apps,
                  color: context.primaryColor,
                ),
              ),
              SettingsClickable(
                onClick: () => context.showSnackBar(
                  appLocale.make_dua_action,
                ),
                title: appLocale.make_dua,
                subtitle: appLocale.make_dua_desc,
                leading: Icon(
                  Icons.favorite_outlined,
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          SettingsSection(
            title: appLocale.about,
            tiles: [
              /*SettingsClickable(
                  onClick: () async {
                    await testNotification();
                  },
                  title: "TEST_NOTIFICATION"),*/
              SettingsClickable(
                onClick: () => showAboutDialog(
                  context: context,
                  applicationName: appLocale.app_name,
                  applicationIcon: Image.asset(
                    'assets/logo.png',
                    width: 55,
                  ),
                  applicationVersion: globalProvider.version,
                  applicationLegalese: 'Open-Source under GPL-V3 License',
                  children: [
                    const Text(
                      'Minimal Adhan is an open-source and free application for the muslim ummah.',
                    ),
                  ],
                ),
                title: 'Azan',
                subtitle:
                    'Version: ${globalProvider.version}, build: ${globalProvider.buildNumber}',
                leading: Image.asset(
                  'assets/logo.png',
                  width: 55,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
