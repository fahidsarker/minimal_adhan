import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimal_adhan/helpers/preferences.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:flutter/services.dart';
import 'package:minimal_adhan/theme.dart';

import 'flip_counter.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({Key? key}) : super(key: key);

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  int count = tasbihCount.value;
  bool? hasVibrate;
  bool? hasAmplitudeControl;

  @override
  void initState() {
    super.initState();
  }

  void changeCounter(int value) {
    tasbihCount.updateValue(value);
    setState(() {
      count = value;
    });

    HapticFeedback.heavyImpact();
  }



  @override
  Widget build(BuildContext context) {
    final txtTheme = count < 9999
        ? context.textTheme.headline1
        : count < 99999
            ? context.textTheme.headline2
            : count < 999999
                ? context.textTheme.headline3
                : count < 9999999
                    ? context.textTheme.headline4
                    : context.textTheme.headline6;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(context.appLocale.tasbih),
          actions: [
            IconButton(
              onPressed: () => changeCounter(0),
              icon: const Icon(Icons.refresh),
              tooltip: context.appLocale.reset,
            )
          ],
        ),

        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => changeCounter(count + 1),
            borderRadius: BorderRadius.circular(20),
            child: Center(
              child: Container(
                height: context.smallerBetweenHeightAndWidth * 0.9,
                width: context.smallerBetweenHeightAndWidth * 0.9,
                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(16),
                ),
                child: AnimatedFlipCounter(
                  value: count,
                  formatDigit: (digit, position) => NumberFormat('',context.appLocale.locale).format(digit),
                  duration: const Duration(milliseconds: 250),
                  textStyle: txtTheme?.copyWith(
                      fontWeight: FontWeight.w300,
                    foreground: Paint()..shader = getOnBackgroundGradient(context).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                  ),
                ),
              ),
            ),
          ),
        ),);
  }
}
