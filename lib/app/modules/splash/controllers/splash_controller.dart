import 'package:get/get.dart';
import 'package:notibox/app/data/repository/settings_repository.dart';
import 'package:notibox/app/routes/app_pages.dart';
import 'package:notibox/app/services/background_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    initPlatformState();
    
    await Future.delayed(Duration(seconds: 1));
    // Check is user already have token and database id
    final token = SettingsRepository.getToken();
    final databaseId = SettingsRepository.getDatabaseId();
    // Go to home if the value is not null
    if (token != null && databaseId != null) {
      Get.offNamed(Routes.HOME);
    } else {
      Get.offNamed(Routes.ONBOARDING);
    }
  }
}
