import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimal_adhan/main.dart';
import 'package:minimal_adhan/models/Adhan.dart';
import 'package:minimal_adhan/prviders/adhanProvider.dart';
import 'package:minimal_adhan/screens/adhan/widgets/AdhanItem.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

const centerPage = 20000;

class AdhanList extends StatelessWidget {
  final PageController _pageController;

  AdhanList(this._pageController);

  @override
  Widget build(BuildContext context) {
    final adhanProvider = context.read<AdhanProvider>();

    return Flexible(
      fit: FlexFit.loose,
      child: PageView.builder(
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
              color: Theme.of(context).brightness == Brightness.light
                  ? onLightCardColor
                  : onDarkCardColor,
            ),
            margin: const EdgeInsets.all(8.0),
            child: _AdhanListView(
                DateTime.now().add(Duration(days: (index - centerPage))),
                index == centerPage),
          );
        },
      ),
    );
  }
}

class _AdhanListView extends StatelessWidget {
  final DateTime _dateTime;
  final bool _scroll;

  _AdhanListView(this._dateTime, this._scroll);

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context)!;
    final NumberFormat timeFormat = NumberFormat('00', appLocale.locale);
    final adhanProvider = Provider.of<AdhanProvider>(context, listen: _scroll);
    final List<Adhan> _adhans = adhanProvider.getAdhanData(_dateTime);
    final index = adhanProvider.currentAdhanIndex;


    return ScrollablePositionedList.builder(
      physics: BouncingScrollPhysics(),
      itemCount: _adhans.length,
      itemBuilder: (_, i) => AdhanItem(_adhans[i], timeFormat),
      initialScrollIndex: _scroll ? index != null ? (index < 2 ? 0 : index - 2) : 0 :0,

    );
  }
}
