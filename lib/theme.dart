import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/prviders/dependencies/GlobalDependencyProvider.dart';
import 'models/app_local.dart';

TextTheme getTextTheme(BuildContext context, String locale) {
  return AppLocale.of(locale).getTextTheme(context);
}

LinearGradient getOnBackgroundGradient({double opacity = 1}) {
  return LinearGradient(colors: [
    const Color(0xFF134E5E).withOpacity(opacity),
    const Color(0xFF71B280).withOpacity(opacity),
  ],);
}

Color getDrawerShadowColor() {
  return Colors.teal;
}

ThemeData getLightTheme(
        BuildContext context, GlobalDependencyProvider globalDependency) =>
    ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            iconTheme: context.theme.iconTheme.copyWith(color: Colors.black),
            systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),),
        cardColor: Colors.white,
        brightness: Brightness.light,
        fontFamily: AppLocale.of(globalDependency.locale).fontFamily,
        textTheme: getTextTheme(context, globalDependency.locale),
        colorScheme: const ColorScheme.light(
          primary: Colors.teal,
          secondary: Colors.blueGrey,
        ),);

ThemeData getDarkTheme(
    BuildContext context, GlobalDependencyProvider globalDependency,) {
  const darkBack = Colors.black;

  return ThemeData(
      bottomSheetTheme:
          context.theme.bottomSheetTheme.copyWith(backgroundColor: darkBack),
      appBarTheme: AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: darkBack,
        systemOverlayStyle: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: Colors.transparent),
      ),
      fontFamily: AppLocale.of(globalDependency.locale).fontFamily,
      textTheme: getTextTheme(context, globalDependency.locale).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white70,
      ),
      canvasColor: darkBack,
      cardColor: darkBack,
      dialogBackgroundColor: darkBack,
      scaffoldBackgroundColor: darkBack,
      backgroundColor: darkBack,

      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF71B280),
        secondary: Colors.white,
      ),);
}
