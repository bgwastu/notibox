import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Horizontal spacing
const Widget horizontalSpaceTiny = SizedBox(width: 4);
const Widget horizontalSpaceSmall = SizedBox(width: 8);
const Widget horizontalSpaceRegular = SizedBox(width: 16);
const Widget horizontalSpaceMedium = SizedBox(width: 24);
const Widget horizontalSpaceLarge = SizedBox(width: 48);

// Vertical spacing
const Widget verticalSpaceTiny = SizedBox(height: 4);
const Widget verticalSpaceSmall = SizedBox(height: 8);
const Widget verticalSpaceRegular = SizedBox(height: 16);
const Widget verticalSpaceMedium = SizedBox(height: 24);
const Widget verticalSpaceLarge = SizedBox(height: 48);

// Screen size helpers
double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

double screenHeightPercentage(BuildContext context, {double percentage = 1}) =>
    screenHeight(context) * percentage;

double screenWidthPercentage(BuildContext context, {double percentage = 1}) =>
    screenWidth(context) * percentage;

// Others
Future hideInput() => SystemChannels.textInput.invokeMethod('TextInput.hide');
const double fabDimension = 56.0;
void setCurrentOverlay({required bool isDarkMode}) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
    statusBarBrightness: isDarkMode ? Brightness.light : Brightness.dark,
  ));
}

