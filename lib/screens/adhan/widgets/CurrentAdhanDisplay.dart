import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimal_adhan/main.dart';
import 'package:minimal_adhan/prviders/adhanProvider.dart';
import 'package:minimal_adhan/screens/adhan/widgets/adhanInfoDialog.dart';
import 'package:minimal_adhan/widgets/timer.dart';
import 'package:provider/provider.dart';
import 'package:minimal_adhan/extensions.dart';

class CurrentAdhanDisplay extends StatelessWidget {
  final String _userAddress;

  CurrentAdhanDisplay(this._userAddress);

  @override
  Widget build(BuildContext context) {
    final headingStyle = context.textTheme.headline1!
        .copyWith(color: context.textTheme.headline6?.color, fontSize: 70);
    final adhanProvider = context.watch<AdhanProvider>();
    final currentAdhan = adhanProvider.currentAdhan;

    return Container(
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => showDialog(
            context: context, builder: (ctx) => const AdhanInfoDialog()),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (currentAdhan != null) ...[
              AutoSizeText(
                currentAdhan.title.toUpperCase(),
                style: headingStyle,
                maxLines: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Countdown(
                    currentAdhan.endTime,
                    locale: context.appLocale.locale,
                    prefix: '${adhanProvider.appLocalization.until_adhan}: ',
                    suffix: '  |  ',
                    style: context.textTheme.bodyText1,
                    rtl: context.appLocale.direction == 'rtl',
                  ),
                  ..._createLocationRow(context)
                ],
              ),
            ] else ...[
              AutoSizeText(
                adhanProvider.appLocalization.adhan_heading,
                style: headingStyle,
                maxLines: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _createLocationRow(context),
              )
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _createLocationRow(BuildContext context) {
    return [
      Icon(Icons.my_location),
      SizedBox(
        width: 8,
      ),
      AutoSizeText(
        _userAddress.length > 15 ? _userAddress.substring(0,15)+"..." : _userAddress,
        style: context.textTheme.bodyText1,
        maxLines: 1,
      )
    ];
  }
}
