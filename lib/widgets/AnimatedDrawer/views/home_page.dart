import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimal_adhan/widgets/AnimatedDrawer/bloc/AnimatedDrawerDependency.dart';
import 'package:minimal_adhan/widgets/AnimatedDrawer/constants/constants.dart';
import 'package:minimal_adhan/widgets/AnimatedDrawer/constants/runtime_variables.dart';

class HomePage extends StatefulWidget {
  final Widget? body;
  final AnimatedDrawerDependency dependency;

  const HomePage({required this.body, required this.dependency});

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      transform: widget.dependency.changeValues(
        widget.dependency.homeXOffSet,
        widget.dependency.homeYOffSet,
        widget.dependency.homeAngle,
      ),
      duration: widget.dependency.setDuration(
        RuntimeVariables.homePageSpeedUserInput ??
            Constants.HOME_SCREEN_DURATION,
      ),
      child: ClipRRect(
        borderRadius: widget.dependency.getBorderRadius(),
        child: widget.body ?? const SizedBox(),
      ),
    );
  }
}
