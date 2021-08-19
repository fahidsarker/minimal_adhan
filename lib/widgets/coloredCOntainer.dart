import 'package:flutter/material.dart';
import 'package:minimal_adhan/main.dart';

Color getColoredContainerColor(BuildContext context){
  return Theme.of(context).brightness == Brightness.light ? onLightCardColor : onDarkCardColor;
}

class ColoredContainer extends StatelessWidget {
  final Color color;
  final Widget child;
  final double radius;

  const ColoredContainer(this.child, this.color, [this.radius = 8.0]);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(radius),
        padding: EdgeInsets.all(radius),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(radius)),
        child: child);
  }
}