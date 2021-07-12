import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notibox/app/config/ui_helpers.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    setCurrentOverlay(Get.isDarkMode);
    Get.find<SplashController>();
    return Scaffold(
      body: Center(
        child: Container(
            width: 60,
            child: Image.asset(
              Get.isDarkMode
                  ? 'assets/logo/512_dark.png'
                  : 'assets/logo/512_light.png',
            )),
      ),
    );
  }
}
