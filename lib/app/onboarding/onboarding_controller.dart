import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:notibox/app/inbox/inbox_service.dart';
import 'package:notibox/app/onboarding/token_onboarding/token_service.dart';
import 'package:notibox/app/settings/settings_repository.dart';
import 'package:notibox/config/constants.dart';
import 'package:notibox/routes/app_pages.dart';
import 'package:notibox/utils/ui_helpers.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingController extends GetxController {
  final _authService = Get.put(TokenService());
  final _notionProvider = Get.put(InboxService());

  final index = Rx<int>(0);
  final tokenController = TextEditingController();
  final tokenFormKey = GlobalKey<FormState>();
  final databaseController = TextEditingController();
  final databaseFormKey = GlobalKey<FormState>();



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
        Get.offNamed(Routes.home);
      } else if (listDatabase.length > 1) {
        EasyLoading.showError('Integration has detects more than one database',
            dismissOnTap: true);
      } else if (listDatabase.isEmpty) {
        EasyLoading.showError('Database not found', dismissOnTap: true);
      }
    } catch (e) {
      await Sentry.captureException(e);
      EasyLoading.showError('Error has been occurred');
      rethrow;
    }
  }

  Future<void> helpToken() async {
    EasyLoading.show();
    try {
      await launch(apiHelpUrl);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> helpDatabase() async {
    EasyLoading.show();
    try {
      launch(integrationHelpUrl);
    } finally {
      EasyLoading.dismiss();
    }
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
        await Sentry.captureException(e);
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
      await launch(databaseTemplateUrl);
    } catch (e) {
      await Sentry.captureException(e);
      EasyLoading.showError('Could not launch URL');
    } finally {
      EasyLoading.dismiss();
    }
  }
}
