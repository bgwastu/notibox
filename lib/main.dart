import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notibox/config/theme.dart';
import 'package:notibox/onboarding/onboarding_page.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
  easyLoadingConfig();
}

void easyLoadingConfig() {
  EasyLoading.instance
    ..maskType = EasyLoadingMaskType.black
    ..animationStyle = EasyLoadingAnimationStyle.scale
    ..indicatorType = EasyLoadingIndicatorType.circle;
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
