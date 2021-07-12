import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:notibox/app/config/ui_helpers.dart';
import 'package:notibox/app/data/auth_provider.dart';
import 'package:notibox/app/data/repository/settings_repository.dart';
import 'package:notibox/app/routes/app_pages.dart';

class OnboardingController extends GetxController {
  final _authService = Get.put(AuthProvider());

  final index = Rx<int>(0);
  final tokenController = TextEditingController();
  final tokenFormKey = GlobalKey<FormState>();
  final databaseController = TextEditingController();
  final databaseFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    // Check is user already have token and database id
    SettingsRepository.instance().then((settings) {
      final token = settings.getToken();
      final databaseId = settings.getDatabaseId();

      // Go to home if the value is not null
      if (token != null && databaseId != null) {
        Get.toNamed(Routes.HOME);
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<void> databaseNext() async {}

  Future<void> tokenNext() async {
    hideInput();
    if (tokenFormKey.currentState!.validate()) {
      EasyLoading.show();

      final isCorrect = await _authService.checkToken(tokenController.text);

      if (!isCorrect) {
        await EasyLoading.dismiss();
        EasyLoading.showError('Token is not valid');
        return;
      }

      // Save token
      await SettingsRepository.instance().then((settings) {
        settings.setToken(tokenController.text);
      });

      await EasyLoading.dismiss();
      index.value++;
    }
  }
}
