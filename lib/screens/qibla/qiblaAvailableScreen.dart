import 'dart:math';

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/models/LocationInfo.dart';
import 'package:minimal_adhan/screens/qibla/SensorNotAvailableScreen.dart';
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

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {


          if (snapshot.data != null) {
            double? direction = snapshot.data!.heading;
            if (direction != null) {
              var heading = direction;

              if ((heading - _lastAngle).abs() > 0.5) {
                _lastAngle = heading;
              } else {
                heading = _lastAngle;
              }

              final match = (heading - qibla.direction).abs() <= 2;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                          fit: BoxFit.fitWidth,
                          width: context.width,
                          color: match
                              ? (Theme.of(context).brightness == Brightness.dark
                                  ? Colors.greenAccent
                                  : Color.fromRGBO(123, 171, 135, 1))
                              : context.accentColor,
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
                                    ? (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.greenAccent
                                        : Color.fromRGBO(123, 171, 135, 1))
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
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    match
                        ? appLocale.qibla_current_direction_matched(
                            '${_numberFormat.format(heading)}')
                        : appLocale.qibla_current_direction_notMatched(
                            '${_numberFormat.format(heading)}'),
                    style: context.textTheme.headline1?.copyWith(
                        fontSize: context.textTheme.headline6?.fontSize,
                        color: match
                            ? (Theme.of(context).brightness == Brightness.dark
                                ? Colors.greenAccent
                                : Color.fromRGBO(123, 171, 135, 1))
                            : context.textTheme.headline6?.color,
                        fontWeight: FontWeight.normal),
                  ),
                ],
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
}
