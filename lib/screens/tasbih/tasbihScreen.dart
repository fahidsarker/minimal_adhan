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

  void changeCounter(int value){
    tasbihCount.updateValue(value);
    setState(() {
      count = value;
    });

    HapticFeedback.heavyImpact();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Tasbih"),
        actions: [
          IconButton(onPressed: ()=> changeCounter(0), icon: const Icon(Icons.refresh), tooltip: 'Reset',)
        ],
      ), //todo add applocale

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: context.width - 50,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                //gradient: getOnBackgroundGradient(context),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: AnimatedFlipCounter(
                 value: count,
                  duration: const Duration(milliseconds: 250),
                  textStyle: Theme.of(context)
                      .textTheme
                      .headline1
                      ?.copyWith(color: context.theme.colorScheme.onBackground),
                ),
              ),
            ),
            const SizedBox(height: 128,),
            _TasbihPlusIcon(onPressed: () => changeCounter(count+1)),
          ],
        ),
      ),
    );
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
