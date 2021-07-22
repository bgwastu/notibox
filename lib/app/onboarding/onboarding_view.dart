import 'package:animations/animations.dart';
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
      // body: Obx(() => IndexedStack(
      //       index: controller.index.value,
      //       children: const [
      //         OnboardingTokenPage(),
      //         OnboardingDatabasePage(),
      //       ],
      //     )),
      body: Obx(() => PageTransitionSwitcher(
            duration: const Duration(milliseconds: 300),
            reverse: !controller.isTokenValid.value,
            transitionBuilder: (
              Widget child,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return SharedAxisTransition(
                child: child,
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
              );
            },
            child: !controller.isTokenValid.value
                ? OnboardingTokenPage()
                : OnboardingDatabasePage(),
          )),
    );
  }
}
