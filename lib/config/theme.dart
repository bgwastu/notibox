import 'package:flutter/material.dart';

const MaterialColor primaryColor = Colors.brown;
const MaterialColor secondaryColor = Colors.amber;

final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
      primarySwatch: primaryColor, accentColor: secondaryColor),
  primaryColor: primaryColor,
  accentColor: secondaryColor,
  appBarTheme: AppBarTheme(
    brightness: Brightness.dark,
    color: primaryColor.shade800,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
);

final darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: primaryColor.shade200,
    primaryVariant: primaryColor.shade200,
    secondary: secondaryColor,
    secondaryVariant: secondaryColor,
  ),
  accentColor: secondaryColor,
  errorColor: Colors.red.shade400,
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
);
