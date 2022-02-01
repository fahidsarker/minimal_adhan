import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:minimal_adhan/widgets/AnimatedDrawer/constants/constants.dart';
import 'package:minimal_adhan/widgets/AnimatedDrawer/constants/runtime_variables.dart';


class AnimatedDrawerDependency {

  double shadowXOffSet = Constants.SHADOW_X_OFFSET_START;
  double shadowYOffSet = Constants.SHADOW_Y_OFFSET_START;
  double shadowAngle = Constants.SHADOW_ANGLE_START;

  double homeXOffSet = Constants.HOME_SCREEN_X_OFFSET_START;
  double homeYOffSet = Constants.HOME_SCREEN_Y_OFFSET_START;
  double homeAngle = Constants.HOME_SCREEN_ANGLE_START;

  bool isDrawerOpen = false;
  void openDrawer() {
    shadowXOffSet = RuntimeVariables.shadowXUserInput ?? Constants.SHADOW_X_OFFSET_END;
    shadowYOffSet = RuntimeVariables.shadowYUserInput ?? Constants.SHADOW_Y_OFFSET_END;
    shadowAngle = RuntimeVariables.shadowAngleUserInput ?? Constants.SHADOW_ANGLE_END;
    homeXOffSet = RuntimeVariables.homePageXUserInput ?? Constants.HOME_SCREEN_X_OFFSET_END;
    homeYOffSet = RuntimeVariables.homePageYUserInput ?? Constants.HOME_SCREEN_Y_OFFSET_END;
    homeAngle = RuntimeVariables.homePageAngleUserInput ?? Constants.HOME_SCREEN_ANGLE_END;
    isDrawerOpen = true;
  }

  /// This function will be called when ever the button is pressed
  /// to close drawer and assign values to Shadow animatedContainer.
  void closeDrawer() {
    shadowXOffSet = Constants.SHADOW_X_OFFSET_START;
    shadowYOffSet = Constants.SHADOW_Y_OFFSET_START;
    shadowAngle = Constants.SHADOW_ANGLE_START;
    homeXOffSet = Constants.HOME_SCREEN_X_OFFSET_START;
    homeYOffSet = Constants.HOME_SCREEN_Y_OFFSET_START;
    homeAngle = Constants.HOME_SCREEN_ANGLE_START;
    isDrawerOpen = false;
  }


  BoxDecoration getDecoration(Color bgColor) {
    return BoxDecoration(
        color: bgColor,
        borderRadius: isDrawerOpen
            ? BorderRadius.circular(10)
            : BorderRadius.circular(0));
  }

  BorderRadius getBorderRadius() {
    return isDrawerOpen
        ? BorderRadius.circular(10)
        : BorderRadius.circular(0);
  }

    Matrix4 changeValues(double xOffSet, double yOffSet, double angle) {
    return Matrix4Transform()
        .translate(x: xOffSet, y: yOffSet)
        .rotate(angle)
        .matrix4;
  }

  Duration setDuration(int duration) {
    return Duration(milliseconds: duration);
  }

  void initSize(BuildContext context) {
    Constants.height = MediaQuery.of(context).size.height;
    Constants.width = MediaQuery.of(context).size.width;
  }
}
