import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/models/Tasbih.dart';
import 'package:minimal_adhan/screens/tasbih/create_tasbih/create_tasbih_dialog.dart';
import 'package:minimal_adhan/screens/tasbih/tasbih_counter/tasbih_counter_screen.dart';
import 'package:minimal_adhan/screens/tasbih/tasbih_counter/tasbih_tap_counter.dart';
import 'package:minimal_adhan/widgets/coloredCOntainer.dart';
import 'package:intl/intl.dart' as intl;
import 'package:percent_indicator/linear_percent_indicator.dart';

class TasbihTile extends StatelessWidget {
  final Tasbih tasbih;

  TasbihTile(this.tasbih);

  @override
  Widget build(BuildContext context) {
    final appLocale = context.appLocale;
    return InkWell(
      onTap: () => context.push(TasbihTapCounter()),
      child: ColoredContainer(
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(
                          tasbih.name,
                          style: context.textTheme.headline6,
                        ),
                      ),
                      if (tasbih.target != null)
                        LinearPercentIndicator(
                          percent: tasbih.ratio,
                          progressColor: Colors.blue,
                          animationDuration: 500,
                          animation: true,
                          lineHeight: 20,
                          barRadius: Radius.circular(8),
                          center: Text("${(tasbih.ratio * 100).toInt()}%"),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/screen_icons/ic_tasbih.png',
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          intl.NumberFormat('00', appLocale.locale)
                              .format(tasbih.counted)
                              .toString(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          getColoredContainerColor(context)),
    );
  }
}
