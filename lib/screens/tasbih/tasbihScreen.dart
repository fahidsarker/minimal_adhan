import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/helpers/preferences.dart';
import 'package:minimal_adhan/screens/tasbih/widgets/tasbih_bud_list.dart';
import 'package:minimal_adhan/theme.dart';
import 'package:minimal_adhan/widgets/flip_counter/int_flip_counter.dart';
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

  final PageController _controller =
      PageController(viewportFraction: 0.1, initialPage: 5);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void changeCounter(int value) {
    tasbihCount.updateValue(value);
    setState(() {
      count = value;
    });

    HapticFeedback.heavyImpact();
    if (value == 0) {
      _controller.animateToPage(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    } else {
      final int nextPage = (_controller.page?.round() ?? 0) + 1;
      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    }
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
      body: InkWell(
        onTap: () => changeCounter(count + 1),
        borderRadius: BorderRadius.circular(20),
        child: Center(
          child: Container(
            height: context.smallerBetweenHeightAndWidth * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                IntFlipCounter(
                  count,
                  textStyle: txtTheme?.copyWith(
                    fontWeight: FontWeight.w300,
                    foreground: Paint()
                      ..shader = getOnBackgroundGradient().createShader(
                        const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                      ),
                  ),
                ),
                const Spacer(),
                TasbihView(_controller)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
