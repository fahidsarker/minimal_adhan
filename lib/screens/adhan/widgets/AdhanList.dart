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
  final bool disablePageScroll;
  final void Function(bool) showHideTop;

  AdhanList(this._pageController, this.showHideTop, this.disablePageScroll);

  @override
  Widget build(BuildContext context) {
    final adhanProvider = context.read<AdhanProvider>();

    return PageView.builder(
      itemCount: centerPage * 2 + 1,
      pageSnapping: true,
      physics: disablePageScroll ? NeverScrollableScrollPhysics() : null,
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
          margin: const EdgeInsets.all(8.0),
          child: _AdhanListView(
             dateTime: DateTime.now().add(Duration(days: (index - centerPage))),
            showHideTop: showHideTop,
            key: Key(index.toString()),
              ),
        );
      },
    );
  }
}

class _AdhanListView extends StatefulWidget {
  final DateTime dateTime;
  final void Function(bool) showHideTop;
  _AdhanListView({required this.dateTime,  Key? key, required this.showHideTop}):super(key: key);

  @override
  State<_AdhanListView> createState() => _AdhanListViewState();
}

class _AdhanListViewState extends State<_AdhanListView> {

  ScrollController controller = ScrollController();

  @override
  void initState() {
    controller.addListener(() {
      widget.showHideTop(controller.offset > 60);
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = context.appLocale;
    final NumberFormat timeFormat = NumberFormat('00', appLocale.locale);
    final adhanProvider = context.read<AdhanProvider>();
    final List<Adhan> _adhans = adhanProvider.getAdhanData(widget.dateTime);

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: _adhans.length+1,
      controller: controller,
      itemBuilder: (_, i) {
        if(i == 0){
          return Container(
            height: CURRENT_ADHAN_DISPLAY_HEIGHT + ADHAN_DATE_CHANGER_HEIGHT,
          );
        }else{
          return AdhanItem(_adhans[i-1], timeFormat);
        }
      },
    );
  }
}
