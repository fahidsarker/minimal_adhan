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

class AdhanAvailableScreen extends StatelessWidget {
  final PageController _adhanListPageController;
  final LocationInfo _locationInfo;

  AdhanAvailableScreen(this._locationInfo)
      : _adhanListPageController = PageController(initialPage: centerPage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Consumer<AdhanProvider>(
          builder: (_, v, child) => v.currentDate.isToday
              ? Container()
              : FloatingActionButton(
                  onPressed: () => _adhanListPageController.animateToPage(
                      centerPage,
                      duration: const Duration(milliseconds: 200), curve: Curves.bounceIn),
                  child: Icon(Icons.refresh),
                ),
        ),
        appBar: AppBar(
          elevation: 0,
          title: Text(context.appLocale.adhan),
        ),
        body: Column(
          children: [
            AdhanDateChanger(_adhanListPageController),
            Expanded(child: AdhanList(_adhanListPageController)),
          ],
        ));
  }
}
