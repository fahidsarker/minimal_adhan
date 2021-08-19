import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimal_adhan/helpers/GPS_location_helper.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/widgets/iconedTextButton.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:minimal_adhan/extensions.dart';

class AdhanInfoDialog extends StatelessWidget {
  const AdhanInfoDialog();

  @override
  Widget build(BuildContext context) {
    final _adhanProvider = context.read<AdhanDependencyProvider>();
    final appLocale = AppLocalizations.of(context)!;
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Row(
        children: [
          Icon(
            Icons.info,
            color: context.accentColor,
          ),
          SizedBox(
            width: 8,
          ),
          Text(appLocale.adhan_info),
        ],
      ),
      content: RichText(
        text: TextSpan(
            text:
                '${appLocale.using_location} ${(_adhanProvider.locationState as LocationAvailable).locationInfo.address}',
            style: DefaultTextStyle.of(context).style,
            children: [
              TextSpan(
                  text: appLocale.location_privacy_short,
                  style: TextStyle(
                      color: context.textTheme.headline6?.color
                          ?.withOpacity(0.6))),
            ]),
      ),
      actions: [
        IconedTextButton(
          iconData: Icons.volume_off,
          text: appLocale.silent_all,
          onPressed: () {
            _adhanProvider.silentAll();
            Navigator.pop(context);
          },
        ),
        IconedTextButton(
          onPressed: () {
            _adhanProvider.updateLocationWithGPS(background: false);
            Navigator.pop(context);
          },
          text: appLocale.update_location,
          iconData: Icons.edit_location,
        ),
        IconedTextButton(
          onPressed: (){},
          iconData: Icons.error,
          text: appLocale.report_an_error,
          color: Colors.red,
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            appLocale.close,
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
