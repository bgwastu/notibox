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
  textButtonTheme: TextButtonThemeData(style: ButtonStyle(textStyle: MaterialStateProperty.all(const TextStyle(fontWeight: FontWeight.bold)))),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
    },
  ),
);

final darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: primaryColor.shade200,
    primaryVariant: primaryColor.shade200,
    secondary: secondaryColor,
    secondaryVariant: secondaryColor,
  ),
  textButtonTheme: TextButtonThemeData(style: ButtonStyle(textStyle: MaterialStateProperty.all(const TextStyle(fontWeight: FontWeight.bold)))),
  accentColor: secondaryColor,
  errorColor: Colors.red.shade400,
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),

);
