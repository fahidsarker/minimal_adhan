import 'package:flutter/material.dart';

class NullableText extends StatelessWidget {
  final String? text;
  final Widget? onNull;
  final TextStyle? style;

  NullableText(this.text, {this.onNull, this.style});

  @override
  Widget build(BuildContext context) {
    final txt = text;
    return txt == null
        ? onNull ?? Container()
        : Text(
            txt,
            style: style,
          );
  }
}
