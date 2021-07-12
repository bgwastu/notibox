import 'package:get/get.dart';
import 'package:notibox/app/data/repository/settings_repository.dart';
import 'package:notibox/app/routes/app_pages.dart';

class SplashController extends GetxController {

  final count = 0.obs;
  @override
  void onInit() async {
    super.onInit();
    await Future.delayed(Duration(seconds: 2));
    // Check is user already have token and database id
    final settings = await SettingsRepository.instance();
    final token = settings.getToken();
    final databaseId = settings.getDatabaseId();
    // Go to home if the value is not null
    if (token != null && databaseId != null) {
      Get.offNamed(Routes.HOME);
    }else {
      Get.offNamed(Routes.ONBOARDING);
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
