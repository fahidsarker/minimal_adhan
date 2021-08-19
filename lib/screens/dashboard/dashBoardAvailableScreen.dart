import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimal_adhan/main.dart';
import 'package:minimal_adhan/models/LocationInfo.dart';
import 'package:minimal_adhan/prviders/adhanProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:minimal_adhan/widgets/coloredCOntainer.dart';
import 'package:minimal_adhan/widgets/timer.dart';
import 'package:provider/provider.dart';
import 'package:minimal_adhan/extensions.dart';

class DashBoardAvailable extends StatelessWidget {
  final LocationInfo _locationInfo;

  const DashBoardAvailable(this._locationInfo);

  @override
  Widget build(BuildContext context) {
    final adhanDependency = context.watch<AdhanDependencyProvider>();
    final appLocale = AppLocalizations.of(context)!;
    final adhanProvider =
        AdhanProvider(adhanDependency, _locationInfo, appLocale);
    final currentAdhan = adhanProvider.currentAdhan;
    final nextAdhan = adhanProvider.nextAdhan;

    final headingStyle = context.textTheme.headline1
        ?.copyWith(color: context.textTheme.headline6?.color, height: 1.5);

    final lowerTextStyle =
        context.textTheme.headline6?.copyWith(color: context.accentColor);

    return Center(
      child: Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? onDarkCardColor
                : onLightCardColor,
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (currentAdhan != null) ...[
              AutoSizeText(
                currentAdhan.title,
                maxLines: 1,
                style: headingStyle,
              ),
              Countdown(
                currentAdhan.endTime,
                locale: appLocale.locale,
                style: lowerTextStyle,
                prefix: ' - ${appLocale.until_adhan} ',
                rtl: context.appLocale.direction == 'rtl',
              ),
            ] else
              AutoSizeText(
                appLocale.adhan,
                maxLines: 1,
                style: headingStyle,
              ),

            Text(
              '${appLocale.next},',
              style: context.textTheme.headline5
                  ?.copyWith(color: context.textTheme.headline6?.color),
            ),
            Text(
              nextAdhan.title,
              style: context.textTheme.headline3
                  ?.copyWith(color: context.textTheme.headline6?.color,),
            ),
            Text(
              ' - ${appLocale.from} ${nextAdhan.formattedStartTime}',
              style: lowerTextStyle,
            ),

            SizedBox(height: 16,),

            AutoSizeText(
              'So remember me, I will remember you.\n- Al Quran',
              style: context.textTheme.headline1?.copyWith(
                  color: context.textTheme.headline6?.color,
                  fontSize: context.textTheme.headline4?.fontSize),
              maxLines: 3,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
