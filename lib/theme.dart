import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minimal_adhan/prviders/dependencies/GlobalDependencyProvider.dart';
import 'extensions.dart';
import 'localization/supportedLangs.dart';

LinearGradient getDrawerBGGradient(BuildContext context) {
  return LinearGradient(
    colors: context.theme.brightness == Brightness.light
        ? [
            Color(0xFF134E5E),
            Color(0xFF71B280),
          ]
        : [
            Color(0xFF0A232A),
            Color(0xFF33503A),
          ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

Color getDrawerShadowColor(BuildContext context) {
  return context.theme.brightness == Brightness.light
      ? Colors.teal
      : Color(0xFF145742);
}

ThemeData getLightTheme(
        BuildContext context, GlobalDependencyProvider globalDependency) =>
    ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            iconTheme: context.theme.iconTheme.copyWith(color: Colors.black),
            systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent)),
        cardColor: Colors.white,
        brightness: Brightness.light,
        fontFamily: getFont(globalDependency.locale),
        textTheme: getTextTheme(context, globalDependency.locale),
        colorScheme: ColorScheme.light(
          primary: Colors.blue,
          secondary: Colors.blueGrey,
        ));

ThemeData getDarkTheme(
    BuildContext context, GlobalDependencyProvider globalDependency) {
  final darkBack = Color.fromRGBO(29, 51, 64, 1);

  return ThemeData(
      bottomSheetTheme:
          context.theme.bottomSheetTheme.copyWith(backgroundColor: darkBack),
      appBarTheme: AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: darkBack,
        systemOverlayStyle: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: Colors.transparent),
      ),
      fontFamily: getFont(globalDependency.locale),
      textTheme: getTextTheme(context, globalDependency.locale).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white70,
      ),
      canvasColor: darkBack,
      cardColor: darkBack,
      dialogBackgroundColor: darkBack,
      scaffoldBackgroundColor: darkBack,
      backgroundColor: darkBack,
      snackBarTheme: context.theme.snackBarTheme
          .copyWith(backgroundColor: Colors.white.withOpacity(0.8)),
      colorScheme: ColorScheme.dark(
        secondary: Colors.white,
        primary: Colors.blueAccent,
        brightness: Brightness.dark,
      ));
}
