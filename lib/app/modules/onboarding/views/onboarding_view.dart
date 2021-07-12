import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notibox/app/config/ui_helpers.dart';
import 'package:notibox/app/modules/onboarding/views/page/onboarding_database_page.dart';
import 'package:notibox/app/modules/onboarding/views/page/onboarding_token_page.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  @override
  Widget build(BuildContext context) {
    setCurrentOverlay(Get.isDarkMode);

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.index.value,
            children: [
              OnboardingTokenPage(),
              OnboardingDatabasePage(),
            ],
          )),
    );
  }
}
