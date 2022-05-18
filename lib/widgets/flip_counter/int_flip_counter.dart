/*
import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';

class IntFlipCounter extends StatelessWidget {

  final int value;

  const IntFlipCounter(this.value);

  @override
  Widget build(BuildContext context) {
    final style = DefaultTextStyle.of(context).style;
    final prototypeDigit = TextPainter(
      text: TextSpan(text: context.appLocale.eight, style: style),
      textDirection: context.appLocale.direction == 'rtl' ? TextDirection.rtl : TextDirection.ltr,
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
        color: color,
        position: i,
      );
      integerWidgets.add(digit);
    }

    return Container();
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
      duration: const Duration(milliseconds: 300),
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
              _buildSingleDigit(
                digit: whole % 10,
                offset: h * decimal,
                opacity: 1 - decimal,
                position: position,
                formatDigit: formatDigit,
              ),
              _buildSingleDigit(
                digit: (whole + 1) % 10,
                offset: h * decimal - h,
                opacity: decimal,
                position: position,
                formatDigit: formatDigit,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSingleDigit({
    required int digit,
    required double offset,
    required double opacity,
  }) {
    // Try to avoid using the `Opacity` widget when possible, for performance.
    return Positioned(
      bottom: offset,
      child: Text(
        digit.localizeTo(context.),
        style: TextStyle(color: color.withOpacity(opacity.clamp(0, 1))),
      );,
    );
  }
}*/
