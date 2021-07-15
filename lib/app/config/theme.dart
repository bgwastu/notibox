import 'package:flutter/material.dart';

class AppThemes {
  static const MaterialColor primaryColor = Colors.brown;
  static const MaterialColor secondaryColor = Colors.amber;

  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSwatch(primarySwatch: primaryColor, accentColor: secondaryColor),
    primaryColor: primaryColor,
    accentColor: secondaryColor,
    appBarTheme: AppBarTheme(
      brightness: Brightness.dark,
      color: primaryColor.shade800,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: primaryColor.shade200,
      primaryVariant: primaryColor.shade200,
      secondary: secondaryColor,
      secondaryVariant: secondaryColor,
    ),
    accentColor: secondaryColor,
    errorColor: Colors.red.shade400,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}
