import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:notibox/app/config/theme.dart';
import 'package:notibox/app/config/ui_helpers.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Notibox",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: AppThemes.lightTheme,
      builder: EasyLoading.init(),
      darkTheme: AppThemes.darkTheme,
      debugShowCheckedModeBanner: false,
      onReady: () {
        setCurrentOverlay(Get.isDarkMode);
      },
    ),
  );
  easyLoadingConfig();
}

void easyLoadingConfig() {
  EasyLoading.instance
    ..maskType = EasyLoadingMaskType.black
    ..animationStyle = EasyLoadingAnimationStyle.scale
    ..animationDuration = Duration(milliseconds: 100)
    ..indicatorWidget = CircularProgressIndicator(
      color: Colors.white,
    );
}
