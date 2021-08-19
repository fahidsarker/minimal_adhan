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
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      height: context.height * 0.20,

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
                  Icon(Icons.my_location),
                  SizedBox(
                    width: 8,
                  ),
                  AutoSizeText(
                    _userAddress,
                    style: context.textTheme.bodyText1,
                    maxLines: 1,
                  )
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
                children: [
                  Icon(Icons.my_location),
                  SizedBox(
                    width: 8,
                  ),
                  AutoSizeText(
                    _userAddress,
                    style: context.textTheme.bodyText1,
                    maxLines: 1,
                  )
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
