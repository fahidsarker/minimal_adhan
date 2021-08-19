import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:minimal_adhan/dragger.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:minimal_adhan/models/Adhan.dart';
import 'package:minimal_adhan/prviders/adhanPlayBackProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/screens/settings/widgets/SettingsTile.dart';
import 'package:minimal_adhan/screens/settings/widgets/settingsSection.dart';
import 'package:minimal_adhan/widgets/NumberSpinner.dart';
import 'package:provider/provider.dart';


class NotifySelectBottomSheet extends StatelessWidget {
  final Adhan _adhan;

  NotifySelectBottomSheet(this._adhan);


  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context)!;
    final adhanDependency = context.watch<AdhanDependencyProvider>();
    final notifyDelay = adhanDependency.getNotifyBefore(_adhan.type);
    final adhanPlayback = context.watch<AdhanPlayBackProvider>();
    final playing = adhanPlayback.playing;
    final currentNotify = adhanDependency.notifyID(_adhan.type);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: GestureDetector(
        onTap: () {},
        child: DraggableScrollableSheet(
          minChildSize: 0.4,
          builder: (_, controller) => Container(
            margin: EdgeInsets.only(top: 32),
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: SingleChildScrollView(
              controller: controller,
              child: Column(
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Dragger(),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    '${_adhan.title} ${appLocale.notification}',
                    style: context.textTheme.headline5
                        ?.copyWith(color: context.textTheme.headline6?.color),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SettingsSection(title: appLocale.type, tiles: [
                    SettingsClickable(
                      onClick: () {
                        adhanDependency.changeNotifyType(_adhan.type, 0);
                      },
                      title: appLocale.silent,
                      leading: Icon(Icons.notifications_off),
                      selected: currentNotify == 0,
                    ),
                    SettingsClickable(
                      onClick: () {
                        adhanDependency.changeNotifyType(_adhan.type, 1);
                      },
                      title: appLocale.notification_only,
                      leading: Icon(Icons.notifications),
                      selected: currentNotify == 1,
                    ),
                    SettingsClickable(
                      onClick: () {
                        adhanDependency.changeNotifyType(_adhan.type, 2);
                      },
                      title: appLocale.ringtone,
                      leading: Icon(Icons.volume_up),
                      selected: currentNotify == 2,
                      trailing: IconButton(
                        onPressed: () => adhanPlayback.playBack(2),
                        icon:
                            Icon(playing == 2 ? Icons.stop : Icons.play_arrow),
                      ),
                    ),
                    SettingsClickable(
                      onClick: () {
                        adhanDependency.changeNotifyType(_adhan.type, 3);
                      },
                      title: appLocale.adhan_mecca,
                      leading: Icon(Icons.volume_up),
                      selected: currentNotify == 3,
                      trailing: IconButton(
                        onPressed: () => adhanPlayback.playBack(3),
                        icon:
                            Icon(playing == 3 ? Icons.stop : Icons.play_arrow),
                      ),
                    ),
                    SettingsClickable(
                      onClick: () {
                        adhanDependency.changeNotifyType(_adhan.type, 4);
                      },
                      title: appLocale.adhan_medina,
                      leading: Icon(Icons.volume_up),
                      selected: currentNotify == 4,
                      trailing: IconButton(
                        onPressed: () => adhanPlayback.playBack(4),
                        icon:
                            Icon(playing == 4 ? Icons.stop : Icons.play_arrow),
                      ),
                    ),
                  ]),
                  SettingsSection(title: appLocale.timing, tiles: [
                    SettingsToggle(
                      onToggle: (val) => val
                          ? adhanDependency.changeNotifyDelay(
                              _adhan.type, -5)
                          : adhanDependency.changeNotifyDelay(
                              _adhan.type, 0),
                      title: appLocale.inexact_notify,
                      value: notifyDelay != 0,
                    ),
                    if (notifyDelay != 0)
                      SettingsClickable(
                          onClick: () {
                            showDialog(
                              context: context,
                              builder: (_) => NumberSpinner(
                                title: appLocale.click_to_change,
                                initialIndex: notifyDelay,
                                start: -59,
                                end: (_adhan.timeOfWaqt.inMinutes
                                                .toInt() -
                                            2) >
                                        59
                                    ? 59
                                    : (_adhan.timeOfWaqt.inMinutes
                                            .toInt() -
                                        2),
                                onChanged: (val) {
                                  adhanDependency.changeNotifyDelay(
                                      _adhan.type, val);
                                },
                              ),
                            );
                          },
                          title: notifyDelay < 0
                              ? appLocale.notify_me_before(
                                  NumberFormat('00', appLocale.locale)
                                      .format((notifyDelay * -1)))
                              : appLocale.notify_me_after(
                                  NumberFormat('00', appLocale.locale)
                                      .format((notifyDelay)),
                                ),
                          subtitle: appLocale.click_to_change,
                          leading: null)
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
