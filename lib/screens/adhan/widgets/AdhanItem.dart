import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimal_adhan/models/Adhan.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/prviders/adhanPlayBackProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/screens/notificationChooser/notifySelectBottomSheet.dart';
import 'package:minimal_adhan/widgets/coloredCOntainer.dart';
import 'package:minimal_adhan/widgets/timer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class AdhanItem extends StatelessWidget {
  static const _radius = 10.0;
  static const _padding = 8.0;
  static const _margin = 8.0;
  final Adhan _adhan;
  final NumberFormat formatter;

  const AdhanItem(this._adhan, this.formatter);

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context)!;

    final adhanTitleStyle = context.textTheme.headline5
        ?.copyWith(color: context.textTheme.headline6?.color);
    final iconSize = 40.0;
    final adhanDependency = context.watch<AdhanDependencyProvider>();
    final notifyID = adhanDependency.notifyID(_adhan.type);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border:
            _adhan.isCurrent ? Border.all(color: context.secondaryColor) : null,
        borderRadius: BorderRadius.circular(_radius),
        color: getColoredContainerColor(context),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(_radius),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => ChangeNotifierProvider(
              create: (_) => AdhanPlayBackProvider(),
              child: NotifySelectBottomSheet(_adhan),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(_padding),
          child: Row(
            children: [
              Icon(
                notifyID == 0
                    ? Icons.notifications_off
                    : notifyID == 1
                        ? Icons.notifications_on_rounded
                        : Icons.volume_up,
                color: context.textTheme.headline6?.color,
                size: iconSize,
              ),
              SizedBox(
                width: 8.0,
              ),
              _VerticalDivider(iconSize),
              SizedBox(
                width: 8.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _adhan.title.toUpperCase(),
                    style: adhanTitleStyle,
                  ),
                  Text(
                    '${_adhan.formattedStartTime} - ${_adhan.formattedEndTime}\n${getformatDuration(_adhan.timeOfWaqt, formatter, showSeconds: false, hour: ' ${appLocale.hour} ', minute: ' ${appLocale.minute}')}',
                    style: context.textTheme.bodyText1,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  final double length;

  const _VerticalDivider(this.length);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black)
          .withOpacity(0.5),
      child: SizedBox(
        width: 1,
        height: length,
      ),
    );
  }
}
