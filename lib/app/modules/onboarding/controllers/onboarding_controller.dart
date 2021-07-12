import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:notibox/app/config/ui_helpers.dart';
import 'package:notibox/app/data/auth_provider.dart';

class OnboardingController extends GetxController {
  final _authService = Get.put(AuthProvider());

  final index = Rx<int>(0);
  final tokenController = TextEditingController();
  final tokenFormKey = GlobalKey<FormState>();


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

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

      await EasyLoading.dismiss();
      index.value++;
    }
  }
}
