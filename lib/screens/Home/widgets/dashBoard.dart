import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/helpers/GPS_location_helper.dart';
import 'package:minimal_adhan/models/Adhan.dart';
import 'package:minimal_adhan/models/LocationInfo.dart';
import 'package:minimal_adhan/prviders/adhanProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/screens/adhan/widgets/adhanInfoDialog.dart';
import 'package:minimal_adhan/widgets/coloredCOntainer.dart';
import 'package:minimal_adhan/widgets/iconedTextButton.dart';
import 'package:minimal_adhan/widgets/timer.dart';
import 'package:provider/src/provider.dart';

const DASHBOARD_TOP_HEIGHT = 236.0;

class DashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locationState =
        context.watch<AdhanDependencyProvider>().locationState;
    final adhanDependency = context.watch<AdhanDependencyProvider>();

    final appLocale = context.appLocale;

    final adhanProvider = locationState is LocationAvailable
        ? AdhanProvider(adhanDependency, locationState.locationInfo, appLocale)
        : null;

    final currentAdhan = adhanProvider?.currentAdhan;
    final nextAdhan = adhanProvider?.nextAdhan;

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
          children: _buildLayout(
              context: context,
              adhanDependencyProvider: adhanDependency,
              locationState: locationState,
              currentAdhan: currentAdhan,
              nextAdhan: nextAdhan,
              headingStyle: headingStyle),
        ),
      ),
    );
  }

  List<Widget> _buildLayout(
      {required BuildContext context,
      required AdhanDependencyProvider adhanDependencyProvider,
      required LocationState locationState,
      required Adhan? currentAdhan,
      required Adhan? nextAdhan,
      TextStyle? headingStyle}) {
    final appLocale = context.appLocale;
    if ((locationState is LocationNotAvailable))
      return [
        AutoSizeText(
          appLocale.location_required,
          style: context.textTheme.headline6?.copyWith(color: Colors.red),
          maxLines: 1,
        ),
        Text(locationState.cause),
        if (locationState.cause !=
                LOCATION_NA_CAUSE_PERMISSION_DENIED_FOREVER &&
            locationState.cause != LOCATION_NA_CAUSE_FINDING)
          ElevatedButton(
              onPressed: () => adhanDependencyProvider.updateLocationWithGPS(
                  background: false),
              child: Text(appLocale.update_location)),
      ];
    else if (locationState is LocationFinding)
      return [
        AutoSizeText(
          appLocale.adhan,
          style: headingStyle,
          maxLines: 1,
        ),
        LinearProgressIndicator(),
      ];
    else if (currentAdhan != null && nextAdhan != null)
      return [
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
      ];
    else if (nextAdhan != null)
      return [
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
      ];

    return [];
  }
}
