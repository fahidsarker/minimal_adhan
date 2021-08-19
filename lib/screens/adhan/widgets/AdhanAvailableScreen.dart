import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimal_adhan/models/LocationInfo.dart';
import 'package:minimal_adhan/prviders/adhanProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/screens/adhan/widgets/AdhanDateChanger.dart';
import 'package:minimal_adhan/screens/adhan/widgets/AdhanList.dart';
import 'package:minimal_adhan/screens/adhan/widgets/CurrentAdhanDisplay.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdhanAvailableScreen extends StatelessWidget {
  final PageController _adhanListPageController;
  final LocationInfo _locationInfo;

  AdhanAvailableScreen(this._locationInfo)
      : _adhanListPageController = PageController(initialPage: centerPage);

  @override
  Widget build(BuildContext context) {
    final adhanDependencyProvider = context.watch<AdhanDependencyProvider>();

    return ChangeNotifierProvider(
      create: (_) => AdhanProvider(adhanDependencyProvider, _locationInfo,
          AppLocalizations.of(context)!),
      child: Column(
        children: [
          CurrentAdhanDisplay(_locationInfo.address),
          AdhanDateChanger(_adhanListPageController),
          SizedBox(
            height: 8.0,
          ),
          AdhanList(_adhanListPageController),
        ],
      ),
    );
  }
}
