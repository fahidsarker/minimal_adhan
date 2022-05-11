import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:minimal_adhan/helpers/preferences.dart';
import 'package:minimal_adhan/theme.dart';
import 'package:minimal_adhan/widgets/coloredCOntainer.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:flutter/services.dart';

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
          title: Text("Tasbih"),
          actions: [
            IconButton(
              onPressed: () => changeCounter(0),
              icon: const Icon(Icons.refresh),
              tooltip: 'Reset',
            )
          ],
        ), //todo add applocale

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
                  color: (context.isDarkMode ? Colors.white : Colors.black)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: AnimatedFlipCounter(
                  value: count,
                  duration: const Duration(milliseconds: 250),
                  textStyle: txtTheme?.copyWith(
                      color: context.theme.colorScheme.onBackground,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ),
        ));
  }
}

class _TasbihPlusIcon extends StatelessWidget {
  final void Function() onPressed;

  const _TasbihPlusIcon({required this.onPressed});

  static const sizes = [100.0, 80.0, 60.0];
  static const radius = 5000.0;
  static const darkColors = [Colors.white, Colors.blue, Colors.black];
  static const lightColors = [Colors.black, Colors.blue, Colors.white];

  Container getBackContainer(
      {required Color? color, required double size, required Widget child}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: color,
      ),
      child: Center(child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.isDarkMode ? darkColors : lightColors;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(radius),
      child: getBackContainer(
        color: colors[0],
        size: sizes[0],
        child: getBackContainer(
          color: colors[1],
          size: sizes[1],
          child: getBackContainer(
            color: colors[2],
            size: sizes[2],
            child: const Icon(
              Icons.add,
              size: 50,
            ),
          ),
        ),
      ),
    );
  }
}
