import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/models/Adhan.dart';
import 'package:minimal_adhan/prviders/adhanProvider.dart';
import 'package:minimal_adhan/screens/adhan/widgets/AdhanDateChanger.dart';
import 'package:minimal_adhan/screens/adhan/widgets/AdhanItem.dart';
import 'package:minimal_adhan/screens/adhan/widgets/CurrentAdhanDisplay.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const centerPage = 20000;

class AdhanList extends StatelessWidget {
  final PageController _pageController;


  AdhanList(this._pageController);

  @override
  Widget build(BuildContext context) {
    final adhanProvider = context.read<AdhanProvider>();

    return PageView.builder(
      itemCount: centerPage * 2 + 1,
      pageSnapping: true,
      controller: _pageController,
      onPageChanged: (newPage) {
        adhanProvider.changeDayOfDate(newPage - centerPage);
      },
      itemBuilder: (ctx, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            /*color: Theme.of(context).brightness == Brightness.light
                  ? onLightCardColor
                  : onDarkCardColor,*/
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: _AdhanListView(
            dateTime: DateTime.now().add(Duration(days: (index - centerPage))),
            key: Key(index.toString()),
          ),
        );
      },
    );
  }
}

class _AdhanListView extends StatelessWidget {
  final DateTime dateTime;

  _AdhanListView({required this.dateTime, Key? key,})
      : super(key: key);



  @override
  Widget build(BuildContext context) {
    final appLocale = context.appLocale;
    final NumberFormat timeFormat = NumberFormat('00', appLocale.locale);
    final adhanProvider = context.read<AdhanProvider>();
    final List<Adhan> _adhans = adhanProvider.getAdhanData(dateTime);

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: _adhans.length,
      itemBuilder: (_, i) {
        return Padding(
          padding:  EdgeInsets.only(top: i == 0 ? 16 : 0, bottom: i == _adhans.length -1 ? 32 : 0),
          child: AdhanItem(_adhans[i], timeFormat),
        );
      },
    );
  }
}
