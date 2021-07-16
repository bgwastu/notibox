import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:notibox/app/config/constants.dart';
import 'package:notibox/app/config/ui_helpers.dart';
import 'package:notibox/app/data/auth_provider.dart';
import 'package:notibox/app/data/notion_provider.dart';
import 'package:notibox/app/data/repository/settings_repository.dart';
import 'package:notibox/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingController extends GetxController {
  final _authService = Get.put(AuthProvider());
  final _notionProvider = Get.put(NotionProvider());

  final index = Rx<int>(0);
  final tokenController = TextEditingController();
  final tokenFormKey = GlobalKey<FormState>();
  final databaseController = TextEditingController();
  final databaseFormKey = GlobalKey<FormState>();

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

  Future<void> databaseNext() async {
    // Test database
    EasyLoading.show(status: 'Checking a database...');
    // Check database
    // When system detect 2 database, system will throw error
    // If there is 1 database, then save the id and go to dashboard
    try {
      final listDatabase = await _notionProvider.getListDatabase();
      EasyLoading.dismiss();

      if (listDatabase.length == 1) {
        SettingsRepository.setDatabaseId(listDatabase.first.id);
        Get.offNamed(Routes.HOME);
      } else if (listDatabase.length > 1) {
        EasyLoading.showError('Integration has detects more than one database',
            dismissOnTap: true);
      } else if (listDatabase.isEmpty) {
        EasyLoading.showError('Database not found', dismissOnTap: true);
      }
    } catch (e) {
      EasyLoading.showError('Error has been occurred');
      throw e;
    }
  }

  Future<void> helpToken() async {
    EasyLoading.show();
    await launch(API_HELP_URL);
    EasyLoading.dismiss();
  }

  Future<void> helpDatabase() async {
    EasyLoading.show();
    launch(INTEGRATION_HELP_URL);
    EasyLoading.dismiss();
  }

  Future<void> tokenNext() async {
    hideInput();
    if (tokenFormKey.currentState!.validate()) {
      EasyLoading.show();

      try {
        final isCorrect = await _authService.checkToken(tokenController.text);
        if (!isCorrect) {
          await EasyLoading.dismiss();
          EasyLoading.showError('Token is not valid');
          return;
        }
      } catch (e) {
        EasyLoading.showError('Error has occurred');
      }

      // Save token
      SettingsRepository.setToken(tokenController.text);

      await EasyLoading.dismiss();
      index.value++;
    }
  }

  Future<void> duplicateDatabase() async {
    EasyLoading.show();
    try {
      await launch(DATABASE_TEMPLATE_URL);
    } catch (e) {
      EasyLoading.showError('Could not launch URL');
    } finally {
      EasyLoading.dismiss();
    }
  }
}
