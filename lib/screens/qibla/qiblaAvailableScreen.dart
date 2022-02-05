import 'dart:math';

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/models/LocationInfo.dart';
import 'package:minimal_adhan/screens/qibla/SensorNotAvailableScreen.dart';
import 'package:minimal_adhan/theme.dart';
import 'package:minimal_adhan/widgets/coloredCOntainer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:minimal_adhan/widgets/loading.dart';

class QiblaAvailableScreen extends StatelessWidget {
  final LocationInfo _locationInfo;

  const QiblaAvailableScreen(this._locationInfo);

  @override
  Widget build(BuildContext context) {
    final qibla =
        Qibla(Coordinates(_locationInfo.latitude, _locationInfo.longitude));
    final qiblaDirection = 2 * pi * (qibla.direction / 360);
    double _lastAngle = 0;
    final appLocale = AppLocalizations.of(context)!;
    final NumberFormat _numberFormat = NumberFormat('##.#', appLocale.locale);

    final compassHeight = context.smallerBetweenHeightAndWidth * 0.6;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data != null) {
            double? direction = data.heading;
            if (direction != null) {
              var heading = direction;
              if (heading < 0) {
                heading += 365;
              }
              if ((heading - _lastAngle).abs() > 0.5) {
                _lastAngle = heading;
              } else {
                heading = _lastAngle;
              }

              final match = (heading - qibla.direction).abs() <= 2;

              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          gradient: getOnBackgroundGradient(context),
                          borderRadius: BorderRadius.circular(16)),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'You are facing',
                              style: context.textTheme.headline6
                                  ?.copyWith(color: Colors.white),
                            ),
                            Text(
                              match
                                  ? '${context.appLocale.qibla}'
                                  : '${getHeadingName(heading)}',
                              style: context.textTheme.headline4
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: getColoredContainerColor(context),
                          borderRadius: BorderRadius.circular(32)),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/needle.svg',
                            width: compassHeight,
                            height: compassHeight,
                            color: match
                                ? context.primaryColor
                                : context.secondaryColor,
                          ),
                          Transform.rotate(
                            angle: -2 * pi * (heading / 360),
                            child: Stack(
                              children: [
                                SvgPicture.asset(
                                  'assets/compass.svg',
                                  fit: BoxFit.fitWidth,
                                  width: context.width,
                                  color: match
                                      ? context.primaryColor
                                      : context.textTheme.headline6!.color,
                                ),
                                Transform.rotate(
                                  angle: qiblaDirection,
                                  child: SvgPicture.asset(
                                    'assets/qibla.svg',
                                    fit: BoxFit.fitWidth,
                                    width: context.width,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              );
            } else {
              return SensorNotSupported();
            }
          } else {
            return Loading();
          }
        },
      ),
    );
  }

  @Deprecated("USe app locale")
  String getHeadingName(double degree) {
    const heading = {
      0: 'North',
      45: 'North-East',
      90: 'East',
      135: 'South-East',
      180: 'South',
      225: 'South-West',
      270: 'West',
      315: 'North-West',
      360: 'North'
    };

    return heading[
            degree.closestTo([0, 45, 90, 135, 180, 225, 270, 315, 360])] ??
        'Unknown';
  }

  @Deprecated('Use App locale')
  String getAccuracyString(int accuracy) {
    return accuracy <= 15
        ? 'High'
        : accuracy <= 30
            ? 'Moderate'
            : accuracy <= 60
                ? 'Low'
                : 'In-Accurate';
  }
}
