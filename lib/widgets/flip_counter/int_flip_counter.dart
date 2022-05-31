import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';

const _duration =  Duration(milliseconds: 300);

class IntFlipCounter extends StatelessWidget {
  final int value;
  final TextStyle? textStyle;

  const IntFlipCounter(this.value, {this.textStyle});

  @override
  Widget build(BuildContext context) {
    final style = DefaultTextStyle.of(context).style.merge(textStyle);
    final prototypeDigit = TextPainter(
      text: TextSpan(text: context.appLocale.eight, style: style),
      textDirection: context.appLocale.text_direction == 'rtl'
          ? TextDirection.rtl
          : TextDirection.ltr,
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
    )..layout();

    List<int> digits = value == 0 ? [0] : [];
    int v = value.abs();
    while (v > 0) {
      digits.add(v);
      v = v ~/ 10;
    }

    digits = digits.reversed.toList(growable: false);

    final integerWidgets = <Widget>[];
    for (int i = 0; i < digits.length; i++) {
      final digit = _SingleDigitFlipCounter(
        key: ValueKey(digits.length - i),
        value: digits[i].toDouble(),
        size: prototypeDigit.size,
      );
      integerWidgets.add(digit);
    }

    return DefaultTextStyle.merge(
      style: style,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRect(
              child: TweenAnimationBuilder(
                // Animate the negative sign (-) appear and disappearing
                duration: _duration,
                tween: Tween(end: value < 0 ? 1.0 : 0.0),
                builder: (_, double v, __) => Center(
                  widthFactor: v,
                  child: Opacity(opacity: v, child: const Text("-")),
                ),
              ),
            ),
            // Draw digits before the decimal point
            ...integerWidgets,
          ],
        ),
      ),
    );
  }
}

class _SingleDigitFlipCounter extends StatelessWidget {
  final double value;
  final Size size;

  const _SingleDigitFlipCounter({
    Key? key,
    required this.size,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween(end: value),
      duration: _duration,
      curve: Curves.easeIn,
      builder: (_, double value, __) {
        final whole = value ~/ 1;
        final decimal = value - whole;
        final w = size.width;
        final h = size.height;

        return SizedBox(
          width: w,
          height: h,
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: h * decimal,
                child: Text(
                  (whole % 10).localizeTo(context.appLocale),
                ),
              ),
              Positioned(
                bottom: h * decimal - h,
                child: Text(
                  ((whole + 1) % 10).localizeTo(context.appLocale),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
