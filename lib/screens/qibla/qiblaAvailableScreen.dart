import 'dart:math';
import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/models/LocationInfo.dart';
import 'package:minimal_adhan/screens/qibla/SensorNotAvailableScreen.dart';
import 'package:minimal_adhan/theme.dart';
import 'package:minimal_adhan/widgets/coloredCOntainer.dart';
import 'package:minimal_adhan/widgets/loading.dart';

class QiblaAvailableScreen extends StatelessWidget {
  final LocationInfo _locationInfo;

  const QiblaAvailableScreen(this._locationInfo);




  @override
  Widget build(BuildContext context) {
    final qibla = Qibla(Coordinates(_locationInfo.latitude, _locationInfo.longitude));
    final qiblaDirection = 2 * pi * (qibla.direction / 360);
    double _lastAngle = 0;
    final appLocale =context.appLocale;

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
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          gradient: getOnBackgroundGradient(),
                          borderRadius: BorderRadius.circular(16)),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              appLocale.you_are_facing,
                              style: context.textTheme.headline6
                                  ?.copyWith(color: Colors.white),
                            ),
                            Text(
                              match
                                  ? appLocale.qibla
                                  : appLocale.getHeadingName(heading),
                              style: context.textTheme.headline4
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 64,
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
                                  color: match
                                      ? context.primaryColor
                                      : context.textTheme.headline6!.color,
                                  width: context.minPanelSize * 0.9,
                                ),
                                Transform.rotate(
                                  angle: qiblaDirection,
                                  child: SvgPicture.asset(
                                    'assets/qibla.svg',
                                    fit: BoxFit.fitWidth,
                                    width: context.minPanelSize * 0.9,
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
              return const SensorNotSupported();
            }
          } else {
            return const Loading();
          }
        },
      ),
    );
  }



  @Deprecated('Use App locale')
  //todo change to app locale
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
