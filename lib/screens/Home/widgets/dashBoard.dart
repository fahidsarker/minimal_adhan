import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/models/LocationInfo.dart';
import 'package:minimal_adhan/prviders/adhanProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/screens/adhan/widgets/adhanInfoDialog.dart';
import 'package:minimal_adhan/widgets/coloredCOntainer.dart';
import 'package:minimal_adhan/widgets/timer.dart';
import 'package:provider/src/provider.dart';

const DASHBOARD_TOP_HEIGHT = 236.0;
class DashBoard extends StatelessWidget {
  final LocationInfo _locationInfo;

  DashBoard(this._locationInfo);

  @override
  Widget build(BuildContext context) {
    final adhanDependency = context.watch<AdhanDependencyProvider>();
    final appLocale = context.appLocale;
    final adhanProvider =
        AdhanProvider(adhanDependency, _locationInfo, appLocale);

    final currentAdhan = adhanProvider.currentAdhan;
    final nextAdhan = adhanProvider.nextAdhan;

    final headingStyle = context.textTheme.headline1
        ?.copyWith(color: context.textTheme.headline6?.color);

    final lowerTextStyle =
        context.textTheme.headline6?.copyWith(color: context.secondaryColor);
    const padding = const EdgeInsets.all(16.0);
    final radius = BorderRadius.circular(15);

    return Container(
      height: DASHBOARD_TOP_HEIGHT,
      child: Padding(
        padding: const EdgeInsets.only(left: 32, bottom: 32, right: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (currentAdhan != null) ...[
              AutoSizeText(
                currentAdhan.title,
                style: headingStyle,
                maxLines: 1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: AutoSizeText(
                  '${appLocale.next}: ${nextAdhan.title} (${nextAdhan.formattedStartTime} - ${nextAdhan.formattedEndTime})',
                  style: context.textTheme.headline6,
                  maxLines: 1,
                ),
              )
            ] else ...[
              Text(
                '${appLocale.next}',
                style: context.textTheme.headline6,
              ),
              Text(
                nextAdhan.title,
                style: context.textTheme.headline3,
              ),
              Text(
                '${nextAdhan.formattedStartTime} - ${nextAdhan.formattedEndTime}',
                style: context.textTheme.bodyText1,
              ),
            ]
          ],
        ),
      ),
    );

    /*Padding(
      padding: padding,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () =>
            showDialog(context: context, builder: (_) => AdhanInfoDialog()),
        child: Container(
          padding: padding,
          width: context.width - 50,
          decoration: BoxDecoration(
              color: getColoredContainerColor(context),
              borderRadius: radius),
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
                style: context.textTheme.headline3?.copyWith(
                  color: context.textTheme.headline6?.color,
                ),
              ),
              Text(
                ' - ${appLocale.from} ${nextAdhan.formattedStartTime}',
                style: lowerTextStyle,
              ),
            ],
          ),
        ),
      ),
    );*/
  }
}
