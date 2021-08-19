import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimal_adhan/prviders/dependencies/AdhanDependencyProvider.dart';
import 'package:minimal_adhan/widgets/NumberSpinner.dart';
import 'package:provider/provider.dart';
import 'package:minimal_adhan/extensions.dart';

class ManualCorrectionScreen extends StatelessWidget {


  ManualCorrectionScreen();

  @override
  Widget build(BuildContext context) {
    final appLocale = context.appLocale;
    final adhanDependency = context.watch<AdhanDependencyProvider>();
    return Scaffold(
      appBar: AppBar(
          actions: [
            PopupMenuButton(
              itemBuilder: (ctx) =>
                  [PopupMenuItem(value: 0, child: Text('Reset'))],
              color: Theme.of(context).scaffoldBackgroundColor,
              onSelected: (_) {
                for (int i = 0; i < 8; i++) {
                  adhanDependency.changeManualCorrection(i, 0);
                }
              },
            )
          ],
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          iconTheme: IconThemeData(color: context.textTheme.headline6?.color),
          title: Text(
            appLocale.adhan_manual_correction,
            style: TextStyle(color: context.textTheme.headline6?.color),
          )),
      body: Container(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemBuilder: (ctx, i) => ListTile(
            title: Text(
              appLocale.getAdhanName(i),
            ),
            subtitle: Text(
              '${NumberFormat('00', appLocale.locale).format(adhanDependency.getManualCorrection(i))} ${appLocale.minute}',
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => NumberSpinner(
                  title: appLocale.getAdhanName(i),
                  initialIndex: adhanDependency.getManualCorrection(i),
                  start: -59,
                  end: 59,
                  onChanged: (newVal) {
                    adhanDependency.changeManualCorrection(i, newVal);
                  },
                ),
              );
            },
          ),
          itemCount: 8,
        ),
      ),
    );
  }
}
