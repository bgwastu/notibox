import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notibox/app/onboarding/database_onboarding/onboarding_database_page.dart';
import 'package:notibox/app/onboarding/token_onboarding/onboarding_token_page.dart';
import 'package:notibox/utils/ui_helpers.dart';
import 'onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  @override
  Widget build(BuildContext context) {
    setCurrentOverlay(isDarkMode: Get.isDarkMode);

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.index.value,
            children: const [
              OnboardingTokenPage(),
              OnboardingDatabasePage(),
            ],
          )),
    );
  }
}
