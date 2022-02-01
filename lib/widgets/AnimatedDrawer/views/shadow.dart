
import 'package:flutter/material.dart';
import 'package:minimal_adhan/widgets/AnimatedDrawer/bloc/AnimatedDrawerDependency.dart';
import 'package:minimal_adhan/widgets/AnimatedDrawer/constants/constants.dart';
import 'package:minimal_adhan/widgets/AnimatedDrawer/constants/runtime_variables.dart';

ShadowState? shadowState;

class Shadow extends StatefulWidget {
  final Color? bgColor;
  final AnimatedDrawerDependency dependency;

  Shadow({required this.bgColor, required this.dependency});

  @override
  ShadowState createState() => ShadowState();
}

class ShadowState extends State<Shadow> {
  @override
  Widget build(BuildContext context) {
    shadowState = this;
    return AnimatedContainer(
        transform: widget.dependency.changeValues(
            widget.dependency.shadowXOffSet, widget.dependency.shadowYOffSet, widget.dependency.shadowAngle),
        duration: widget.dependency.setDuration(
            RuntimeVariables.shadowSpeedUserInput ?? Constants.SHADOW_DURATION),
        decoration:
        widget.dependency.getDecoration(widget.bgColor ?? Constants.SHADOW_COLOR),
        child: SafeArea(
            child:
            Container(width: Constants.width, height: Constants.height)));
  }
}