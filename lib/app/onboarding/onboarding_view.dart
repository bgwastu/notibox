import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notibox/app/onboarding/database_onboarding/onboarding_database_page.dart';
import 'package:notibox/app/onboarding/token_onboarding/onboarding_token_page.dart';
import 'package:notibox/utils/ui_helpers.dart';

import 'onboarding_controller.dart';

class OnboardingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setCurrentOverlay(isDarkMode: Get.isDarkMode);
    final controller = Get.put(OnboardingController());
    return Scaffold(
      body: Obx(() => PageTransitionSwitcher(
            reverse: !controller.isTokenValid.value,
            transitionBuilder: (
              Widget child,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return SharedAxisTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                child: child,
              );
            },
            child: !controller.isTokenValid.value
                ? const OnboardingTokenPage()
                : const OnboardingDatabasePage(),
          )),
    );
  }
}
