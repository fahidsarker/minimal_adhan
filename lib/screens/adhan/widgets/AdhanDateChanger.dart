
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/prviders/adhanProvider.dart';
import 'package:minimal_adhan/screens/adhan/widgets/AdhanList.dart';
import 'package:minimal_adhan/theme.dart';
import 'package:provider/provider.dart';

const _PADDING = 16.0;

class AdhanDateChanger extends StatelessWidget {
  final PageController _adhanListPageController;

  const AdhanDateChanger(this._adhanListPageController);

  Future moveToDate(BuildContext context, DateTime currentDate) async {
    final date = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2070));

    if (date != null) {
      final days = DateTime.now().daysFrom(date);
      _adhanListPageController.jumpToPage(centerPage + days);
    }
  }

  @override
  Widget build(BuildContext context) {
    final adhanProvider = context.watch<AdhanProvider>();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: _PADDING),
      decoration: BoxDecoration(
        gradient: getOnBackgroundGradient(context),
        borderRadius: BorderRadius.circular(16)
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                icon: Icon(
                  Directionality.of(context)
                          .toString()
                          .contains(TextDirection.LTR.value.toLowerCase())
                      ? Icons.keyboard_arrow_left
                      : Icons.keyboard_arrow_right,
                  color: Colors.white,
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AutoSizeText(
                      DateFormat("EEEE, dd MMM yyyy",
                              adhanProvider.appLocalization.locale)
                          .format(adhanProvider.currentDate),
                      style: context.textTheme.headline6
                          ?.copyWith(color: Colors.white),
                    ),
                    const _CustomDivider(),
                    Text(
                      DateFormat(getArabicDate(adhanProvider.currentDate))
                          .format(adhanProvider.currentDate),
                      style: const TextStyle(color: Colors.white),
                    )
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
                  color: Colors.white,
                ),
                onPressed: () {
                  _adhanListPageController.nextPage(
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeIn);
                })
          ],
        ),
      ),
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
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
          width: context.width * 0.5,
          height: 2,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 4.0),
            borderRadius: BorderRadius.circular(4.0),
          )),
    );
  }
}
