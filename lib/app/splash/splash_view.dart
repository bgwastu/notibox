import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notibox/utils/ui_helpers.dart';

import 'splash_controller.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setCurrentOverlay(isDarkMode: Get.isDarkMode);
    Get.put(SplashController());
    return Scaffold(
      body: Center(
        child: SizedBox(
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
