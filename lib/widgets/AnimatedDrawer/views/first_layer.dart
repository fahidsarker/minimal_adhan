import 'package:flutter/material.dart';
import 'package:minimal_adhan/widgets/AnimatedDrawer/constants/constants.dart';

class FirstLayer extends StatelessWidget {
  final Gradient? gradient;

  FirstLayer({required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Constants.height,
      width: Constants.height,
      decoration:
      BoxDecoration(gradient: gradient ?? Constants.BACKGROUND_GRADIENT),
    );
  }
}