import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:notibox/app/data/repository/settings_repository.dart';
import 'package:notibox/app/routes/app_pages.dart';

class SplashController extends GetxController {

  final count = 0.obs;
  @override
  void onInit() async {
    super.onInit();
    // Check is user already have token and database id
    EasyLoading.show();
    final settings = await SettingsRepository.instance();
    final token = settings.getToken();
    final databaseId = settings.getDatabaseId();
    EasyLoading.dismiss();
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
