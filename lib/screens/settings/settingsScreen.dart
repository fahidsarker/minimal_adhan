import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minimal_adhan/localization/supportedLangs.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/DuaDependencyProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/GlobalDependencyProvider.dart';
import 'package:minimal_adhan/screens/settings/bottomsheets/AppLanguagePicker.dart';
import 'package:minimal_adhan/screens/settings/bottomsheets/CalcMehtodChooser.dart';
import 'package:minimal_adhan/screens/settings/bottomsheets/DuaTranslationLangPicker.dart';
import 'package:minimal_adhan/screens/settings/bottomsheets/highLatRuleChooser.dart';
import 'package:minimal_adhan/screens/settings/bottomsheets/madhabChooser.dart';
import 'package:minimal_adhan/screens/settings/bottomsheets/themePicker.dart';
import 'package:minimal_adhan/screens/settings/screens/adhan_visibility_screen.dart';
import 'package:minimal_adhan/screens/settings/screens/manual_correction_screen.dart';
import 'package:minimal_adhan/screens/settings/widgets/SettingsTile.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/screens/settings/widgets/fontsizeSelectorDialog.dart';
import 'package:minimal_adhan/screens/settings/widgets/settingsSection.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      shape: bottomSheetShape);
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final globalProvider = context.watch<GlobalDependencyProvider>();
    final appLocale = AppLocalizations.of(context)!;
    final adhanDependency = context.watch<AdhanDependencyProvider>();
    final duaDependency = context.watch<DuaDependencyProvider>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          appLocale.settings,
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SettingsSection(
            title: appLocale.global,
            tiles: [
              SettingsClickable(
                  onClick: () => buildBottomSheet(AppLanguagePicker(), context),
                  title: appLocale.language,
                  subtitle: appLocale.current_lang,
                  leading: Icon(Icons.language)),
              SettingsClickable(
                onClick: () => buildBottomSheet(ThemePicker(), context),
                title: appLocale.theme,
                subtitle: globalProvider.getThemeModeText(appLocale),
                leading: Icon(Icons.style),
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
                leading: Icon(Icons.calculate),
              ),
              SettingsClickable(
                onClick: () => buildBottomSheet(MadhabChooser(), context),
                title: appLocale.madhab,
                subtitle: [
                  appLocale.hanafi_madhab,
                  appLocale.shafi_madhab
                ][adhanDependency.madhabIndex],
                leading: Icon(Icons.school),
              ),
              SettingsClickable(
                onClick: () => buildBottomSheet(HighLatRuleChooser(), context),
                title: appLocale.high_lat_rule,
                subtitle: adhanDependency.highLatRuleName,
                leading: Icon(Icons.height),
              ),
              SettingsClickable(
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdhanVisibilityScreen(),
                    ),
                  );
                },
                title: appLocale.adhan_visibility,
                subtitle: null,
                leading: Icon(Icons.visibility),
              ),
              SettingsClickable(
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ManualCorrectionScreen(),
                    ),
                  );
                },
                title: appLocale.adhan_manual_correction,
                subtitle: adhanDependency.manualCorrectionAll,
                leading: Icon(Icons.timer_outlined),
              ),
              SettingsToggle(
                  onToggle: (val) async{
                    adhanDependency.changePersistantNotifyStatus(val);
                  },
                  subtitle: appLocale.persistant_notify_desc,
                  title: appLocale.persistant_notify,
                  value: adhanDependency.showPersistant,
                  leading: Icon(Icons.notifications_rounded)),
            ],
          ),
          SettingsSection(
            title: appLocale.dua,
            tiles: [
              SettingsToggle(
                onToggle: duaDependency.changeShowTransliteration,
                title: appLocale.show_transliteration,
                value: duaDependency.showTransliteration,
                leading: Icon(Icons.text_snippet),
              ),
              SettingsToggle(
                onToggle: duaDependency.changeShowTranslation,
                title: appLocale.show_translation,
                value: duaDependency.showTranslation,
                leading: Icon(Icons.translate),
              ),
              if (duaDependency.showTranslation)
                SettingsClickable(
                  onClick: () =>
                      buildBottomSheet(DuaTranslationLangPicker(), context),
                  title: appLocale.translation_lang,
                  subtitle: duaDependency.sameAsPrimaryLang
                      ? appLocale.language
                      : supportedAppLangs.firstWhere((element) =>
                          element['code'] as String ==
                          duaDependency.translationLang)['lang'] as String,
                  leading: Icon(Icons.language),
                ),
              SettingsClickable(
                onClick: () => showDialog(
                  context: context,
                  builder: (_) => FontSizeSelector(
                    arabic: true,
                  ),
                ),
                title: appLocale.arabic_font_size,
                subtitle:
                    '${duaDependency.arabicFontSize.toStringAsFixed(2)} px',
                leading: Icon(Icons.format_size),
              ),
              SettingsClickable(
                onClick: () => showDialog(
                  context: context,
                  builder: (_) => FontSizeSelector(
                    arabic: false,
                  ),
                ),
                title: appLocale.other_font_size,
                subtitle:
                    '${duaDependency.otherFontSize.toStringAsFixed(2)} px',
                leading: Icon(Icons.format_size),
              ),
            ],
          ),
          SettingsSection(
            title: appLocale.support_dev,
            tiles: [
              SettingsClickable(
                onClick: () {},
                title: appLocale.rate_on_play_store,
                subtitle: appLocale.rate_on_play_store_desc,
                leading: Icon(Icons.star_outlined),
              ),
              SettingsClickable(
                onClick: () {},
                title: appLocale.help_us_translate,
                subtitle: appLocale.help_us_translate_desc,
                leading: Icon(Icons.translate),
              ),
              SettingsClickable(
                onClick: () {},
                title: appLocale.github_ripo,
                subtitle: appLocale.github_ripo_desc,
                leading: Icon(Icons.code),
              ),
              SettingsClickable(
                onClick: () {},
                title: appLocale.report_bug,
                subtitle: appLocale.report_bug_desc,
                leading: Icon(Icons.bug_report),
              ),
              SettingsClickable(
                onClick: () {},
                title: appLocale.request_a_feature,
                subtitle: appLocale.request_a_feature_desc,
                leading: Icon(Icons.apps),
              ),
              SettingsClickable(
                onClick: () {},
                title: appLocale.make_dua,
                subtitle: appLocale.make_dua_desc,
                leading: Icon(Icons.favorite_outlined),
              ),
            ],
          ),
          SettingsSection(
            title: 'About',
            tiles: [
              SettingsClickable(
                onClick: () => showAboutDialog(
                  context: context,
                  applicationName: appLocale.minimal_adhan,
                  applicationIcon: SvgPicture.asset(
                    'assets/logo.svg',
                    width: 55,
                    height: 55,
                  ),
                  applicationVersion: globalProvider.version,
                  applicationLegalese: 'Open-Source under GPL-V3 License',
                  children: [
                    Text(
                        'Minimal Adhan is an open-source and free application for the muslim ummah.'),
                  ],
                ),
                title: 'Minimal Adhan',
                subtitle:
                    'Version: ${globalProvider.version}, build: ${globalProvider.buildNumber}',
                leading: SvgPicture.asset(
                  'assets/logo.svg',
                  width: 55,
                  height: 55,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
