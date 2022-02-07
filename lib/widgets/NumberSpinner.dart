import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

List<String> listFromRange(int start, int end, NumberFormat formatter, {String suffix = '', String prefix = ''}){
  assert (start < end);

  final List<String> list = [];
  for (int i = start; i <= end; i++) {
    list.add('$prefix ${formatter.format(i)} $suffix');
  }
  return list;
}
class NumberSpinner extends StatelessWidget {
  final int initialIndex;
  final String title;
  final int start;
  final int end;
  final void Function(int) onChanged;



  const NumberSpinner(
      {required this.title,
        required this.initialIndex,
        required this.start,
        required this.end,
        required this.onChanged,});

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context)!;
    final List<String> minuteList = listFromRange(start, end, NumberFormat('00', appLocale.locale), suffix: appLocale.minute);
    return AlertDialog(
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              appLocale.close,
              style: const TextStyle(color: Colors.red),
            ),
          )
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(title),
        content: SizedBox(
          height: context.height * 0.5,
          width: context.width * 0.5,
          child: ScrollablePositionedList.builder(
            physics: const BouncingScrollPhysics(),
            initialScrollIndex: 59 + initialIndex,
            itemCount: minuteList.length,
            itemBuilder: (ctx, j) => ListTile(
                title: Text(
                  minuteList[j],
                  textAlign: TextAlign.center,
                ),
                selected: initialIndex == (j - 59),
                onTap: () {
                  onChanged(j - 59);
                  Navigator.pop(context);
                },),
          ),
        ),);
  }
}
