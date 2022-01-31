import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minimal_adhan/prviders/dependencies/GlobalDependencyProvider.dart';
import 'extensions.dart';
import 'localization/supportedLangs.dart';

ThemeData getLightTheme(BuildContext context, GlobalDependencyProvider globalDependency) =>
    ThemeData(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          systemOverlayStyle: SystemUiOverlayStyle.light),
      cardColor: Colors.white,
      brightness: Brightness.light,
      fontFamily: getFont(globalDependency.locale),
      textTheme: getTextTheme(context, globalDependency.locale),
      colorScheme: Theme.of(context).colorScheme.copyWith(
        secondary: Colors.blueGrey,
      )
    );

ThemeData getDarkTheme(BuildContext context, GlobalDependencyProvider globalDependency) {
  final darkBack = Color.fromRGBO(29, 51, 64, 1);

  return ThemeData(
      bottomNavigationBarTheme:
      BottomNavigationBarThemeData(backgroundColor: darkBack),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: darkBack),
      appBarTheme: AppBarTheme(
        brightness: Brightness.dark,
        backgroundColor: darkBack,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      fontFamily: getFont(globalDependency.locale),
      textTheme: getTextTheme(context, globalDependency.locale).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white70,
      ),
      canvasColor: darkBack,
      cardColor: darkBack,
      dialogTheme: DialogTheme(backgroundColor: darkBack),
      scaffoldBackgroundColor: darkBack,
      brightness: Brightness.dark,
      backgroundColor: darkBack,
      accentColor: Colors.white
  );
}