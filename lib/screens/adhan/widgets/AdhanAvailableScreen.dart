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
  bool closeTopContainer = false;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final adhanDependencyProvider = context.watch<AdhanDependencyProvider>();
    return ChangeNotifierProvider(
      create: (_) => AdhanProvider(adhanDependencyProvider,
          widget._locationInfo, AppLocalizations.of(context)!),
      child: Stack(
        children: [
          Column(
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: closeTopContainer ? 1 : 0,
                child: AppBar(
                  leading: IconButton(
                      onPressed: closeTopContainer ? () => context.pop() : null,
                      icon: Icon(Icons.arrow_back_rounded)),
                  title: Text("dhkdf"),
                ),
              ),
              Expanded(
                  child: AdhanList(widget._adhanListPageController, (value) => setState(()=> closeTopContainer = value),
                      closeTopContainer)),
            ],
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: closeTopContainer ? 0 : 1,
            child: Column(
              children: [
                Stack(
                  children: [
                    if (closeTopContainer)
                      Container(
                        height: CURRENT_ADHAN_DISPLAY_HEIGHT,
                      )
                    else
                      CurrentAdhanDisplay(widget._locationInfo.address),
                    if (Navigator.canPop(context))
                      IconButton(
                          onPressed: () => context.pop(),
                          icon: Icon(Icons.home)),
                  ],
                ),
                AdhanDateChanger(widget._adhanListPageController),
              ],
            ),
          )
        ],
      ),
    );
  }
}
