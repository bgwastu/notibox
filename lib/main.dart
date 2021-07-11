import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notibox/config/theme.dart';
import 'package:notibox/config/ui_helpers.dart';
import 'package:notibox/onboarding/onboarding_page.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
  easyLoadingConfig();
  setCurrentOverlay(false);
}

void easyLoadingConfig() {
  EasyLoading.instance
    ..maskType = EasyLoadingMaskType.black
    ..animationStyle = EasyLoadingAnimationStyle.scale
    ..animationDuration = Duration(milliseconds: 100)
    ..indicatorWidget = CircularProgressIndicator(color: Colors.white,);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notibox',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      builder: EasyLoading.init(),
      home: OnboardingPage(),
    );
  }
}
