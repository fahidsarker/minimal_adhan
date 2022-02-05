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
    return [
      if (currentAdhan != null)
        Row(
            children: [
              Image.asset(currentAdhan.imageLocation, width: 72,),
              const SizedBox(width: 8,),
              Expanded(
                child: AutoSizeText(
                  currentAdhan.title,
                  style: context.textTheme.headline2?.copyWith(color: context.theme.colorScheme.onBackground),
                  maxLines: 2,
                ),
              )
            ],
        )
      else
        Text(
          appLocale.adhan,
          style: context.textTheme.headline2,
        ),
      if (nextAdhan != null)
        Text(
          '${appLocale.next}: ${nextAdhan.title} (${nextAdhan.formattedStartTime} - ${nextAdhan.formattedEndTime})',
          style: context.textTheme.bodyText1,
        ),

      if(locationState is LocationAvailable)
        _buildLocationRow(context, Icons.my_location, locationState.locationAddressOfLength(25))

    ];
  }

  Widget _buildLocationRow(BuildContext context, IconData iconData, String text){
    return Row(
      children: [
        Icon(iconData, color: context.primaryColor,),
        const SizedBox(width: 8,),
        Text(text, style: TextStyle(color: context.primaryColor),)
      ],
    );
  }
}
