import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/screens/feedback/form_links.dart';
import 'package:minimal_adhan/screens/settings/settingsScreen.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../platform_dependents/method_channel_helper.dart';
import '../../../prviders/dependencies/DuaDependencyProvider.dart';

class Menu extends StatelessWidget {
  final menuButtonTextStyle = const TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildMenuButton(
              name: context.appLocale.github_ripo,
              icon: Icons.code,
              action: () => launch(githubRepoLink)),
          const Divider(color: Colors.white54),
          buildMenuButton(
              name: context.appLocale.share_app,
              icon: Icons.share,
              action: () {
                Share.share(
                    'Azan: Free and No-Ads. Get Prayer times, Dua, Qibla and Tasbih in a single app. Click the following links to download to download it\n'
                        'Android - $playStoreLink\n'
                        'IOS - Coming Soon InshaAllah',
                    subject: context.appLocale.app_name);
              }),
          buildMenuButton(
            name: context.appLocale.rate_on_play_store,
            icon: Icons.rate_review,
            action: () => PlatformCall.openAppStore(),
          ),
          const Divider(color: Colors.white54),
          buildMenuButton(
            name: context.appLocale.settings,
            icon: Icons.settings,
            action: () => context.push(
              ChangeNotifierProvider(
                  create: (_) => DuaDependencyProvider(),
                  child: const SettingsScreen()),
            ),
          ),
        ],
      ),
    );
  }

  TextButton buildMenuButton(
      {required String name,
      required IconData icon,
      required void Function() action}) {
    return TextButton.icon(
      onPressed: action,
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      label: Text(
        name,
        style: menuButtonTextStyle,
      ),
    );
  }
}

