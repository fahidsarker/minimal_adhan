import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/models/Adhan.dart';
import 'package:minimal_adhan/prviders/adhanPlayBackProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/screens/notificationChooser/notifySelectBottomSheet.dart';
import 'package:minimal_adhan/widgets/coloredCOntainer.dart';
import 'package:minimal_adhan/widgets/timer.dart';
import 'package:provider/provider.dart';

class AdhanItem extends StatelessWidget {
  static const _radius = 10.0;
  static const _padding = 8.0;
  final Adhan _adhan;
  final NumberFormat formatter;

  const AdhanItem(this._adhan, this.formatter);

  @override
  Widget build(BuildContext context) {
    final appLocale = context.appLocale;

    final adhanTitleStyle = context.textTheme.headline5
        ?.copyWith(color: context.textTheme.headline6?.color);
    const iconSize = 24.0;
    final adhanDependency = context.watch<AdhanDependencyProvider>();
    final notifyID = adhanDependency.notifyID(_adhan.type);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            shape: const RoundedRectangleBorder(
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
              _adhanIcon,
              /*,*/
              const SizedBox(
                width: 8.0,
              ),
              const _VerticalDivider(iconSize),
              const SizedBox(
                width: 8.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _adhan.title,
                      style: adhanTitleStyle,
                      maxLines: 3,
                    ),
                    Text(
                      '${_adhan.startTime.localizeTimeTo(appLocale)} - ${_adhan.endTime.localizeTimeTo(appLocale)}\n${getformatDuration(_adhan.timeOfWaqt, formatter, showSeconds: false, hour: ' ${appLocale.hour} ', minute: ' ${appLocale.minute}')}',
                      style: context.textTheme.caption,
                    ),
                  ],
                ),
              ),
              Icon(
                notifyID == 0
                    ? Icons.notifications_off_outlined
                    : notifyID == 1
                        ? Icons.notifications_on_outlined
                        : Icons.volume_up_outlined,
                size: iconSize,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget get _adhanIcon {
    return Image.asset(
      _adhan.imageLocation,
      width: 36,
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
