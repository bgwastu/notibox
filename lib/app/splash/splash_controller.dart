import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notibox/app/inbox/home_inbox/home_view.dart';
import 'package:notibox/app/onboarding/onboarding_view.dart';
import 'package:notibox/app/settings/settings_repository.dart';
import 'package:notibox/services/background_service.dart';

class SplashController extends GetxController {
  @override
  Future<void> onInit() async {
    super.onInit();
    initPlatformState();
    
    await Future.delayed(const Duration(seconds: 1));
    // Check is user already have token and database id
    final token = SettingsRepository.getToken();
    final databaseId = SettingsRepository.getDatabaseId();
    // Go to home if the value is not null
    if (token != null && databaseId != null) {
      Navigator.pushReplacement(Get.context!, MaterialPageRoute(builder: (context) => HomeView()));
    } else {
      Navigator.pushReplacement(Get.context!, MaterialPageRoute(builder: (context) => OnboardingView()));

    }
  }
}
