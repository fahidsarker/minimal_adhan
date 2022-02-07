import 'package:flutter/material.dart';
import 'package:minimal_adhan/widgets/AnimatedDrawer/constants/constants.dart';

class ThirdLayer extends StatelessWidget {
  final Widget? menu;

  const ThirdLayer({required this.menu});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Constants.height,
        width: Constants.height,
        color: Colors.transparent,
        child: menu ?? const SizedBox(),);
  }
}
