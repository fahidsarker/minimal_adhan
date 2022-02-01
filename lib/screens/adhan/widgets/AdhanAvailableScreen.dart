import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/models/LocationInfo.dart';
import 'package:minimal_adhan/prviders/adhanProvider.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/screens/adhan/widgets/AdhanDateChanger.dart';
import 'package:minimal_adhan/screens/adhan/widgets/AdhanList.dart';
import 'package:minimal_adhan/screens/adhan/widgets/CurrentAdhanDisplay.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdhanAvailableScreen extends StatefulWidget {
  final PageController _adhanListPageController;
  final LocationInfo _locationInfo;

  AdhanAvailableScreen(this._locationInfo)
      : _adhanListPageController = PageController(initialPage: centerPage);

  @override
  State<AdhanAvailableScreen> createState() => _AdhanAvailableScreenState();
}

class _AdhanAvailableScreenState extends State<AdhanAvailableScreen> {
  @override
  Widget build(BuildContext context) {
    final adhanDependencyProvider = context.watch<AdhanDependencyProvider>();

    return ChangeNotifierProvider(
      create: (_) => AdhanProvider(adhanDependencyProvider, widget._locationInfo,
          AppLocalizations.of(context)!),
      child: Column(
        children: [
          Stack(
            children: [
              CurrentAdhanDisplay(widget._locationInfo.address),
              if (Navigator.canPop(context))
                IconButton(onPressed: () => context.pop(), icon: Icon(Icons.home)),
            ],
          ),
          AdhanDateChanger(widget._adhanListPageController),
          SizedBox(
            height: 8.0,
          ),
          AdhanList(widget._adhanListPageController),
        ],
      ),
    );
  }
}
