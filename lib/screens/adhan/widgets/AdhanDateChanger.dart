import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:minimal_adhan/prviders/adhanProvider.dart';
import 'package:provider/provider.dart';
import 'AdhanList.dart';
import 'package:minimal_adhan/extensions.dart';

class AdhanDateChanger extends StatelessWidget {
  final PageController _adhanListPageController;

  const AdhanDateChanger(this._adhanListPageController);

  void moveToDate(BuildContext context, DateTime currentDate) async {
    final date = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2070));

    if (date != null) {
      final days = daysBetween(DateTime.now(), date);
      _adhanListPageController.jumpToPage(centerPage + days);
    }
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  @override
  Widget build(BuildContext context) {
    final adhanProvider = context.watch<AdhanProvider>();
    return Column(
      children: [
        Opacity(
          opacity: adhanProvider.currentDate.isToday ? 0 : 1,
          child: TextButton(
            onPressed: () => adhanProvider.currentDate.isToday
                ? null
                : _adhanListPageController.jumpToPage(centerPage),
            child: Text(adhanProvider.appLocalization.show_today),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                icon: Icon(
                  Directionality.of(context)
                          .toString()
                          .contains(TextDirection.LTR.value.toLowerCase())
                      ? Icons.keyboard_arrow_left
                      : Icons.keyboard_arrow_right,
                ),
                onPressed: () {
                  _adhanListPageController.previousPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeIn);
                }),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => moveToDate(context, adhanProvider.currentDate),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(DateFormat(
                            "EEEE, dd MMM yyyy",
                            adhanProvider.appLocalization.locale)
                        .format(adhanProvider.currentDate)),
                    _CustomDivider(),
                    Text(DateFormat(getArabicDate(adhanProvider.currentDate))
                        .format(adhanProvider.currentDate))
                  ],
                ),
              ),
            ),
            IconButton(
                icon: Icon(
                  Directionality.of(context)
                          .toString()
                          .contains(TextDirection.LTR.value.toLowerCase())
                      ? Icons.keyboard_arrow_right
                      : Icons.keyboard_arrow_left,
                ),
                onPressed: () {
                  _adhanListPageController.nextPage(
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeIn);
                })
          ],
        ),
      ],
    );
  }

  String getArabicDate(DateTime date) {
    HijriCalendar.setLocal('ar');
    var hDate = HijriCalendar.fromDate(date);
    return '${hDate.hDay}-${hDate.getShortMonthName()}-${hDate.hYear}';
  }
}

class _CustomDivider extends StatelessWidget {
  const _CustomDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Container(
          width: context.width * 0.4,
          height: 2,
          decoration: BoxDecoration(
            color: context.accentColor,
            border: Border.all(width: 2.0),
            borderRadius: BorderRadius.circular(4.0),
          )),
    );
  }
}
