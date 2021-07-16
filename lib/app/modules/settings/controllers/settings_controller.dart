import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:notibox/app/config/constants.dart';
import 'package:notibox/app/data/repository/settings_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsController extends GetxController {
  void toggleDarkMode({required bool isDarkMode}) {
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
    SettingsRepository.setThemeMode(isDarkMode: isDarkMode);
  }

  void updateToken(String token) => SettingsRepository.setToken(token);
  void updateDatabaseId(String databaseId) =>
      SettingsRepository.setDatabaseId(databaseId);
  String getToken() => SettingsRepository.getToken()! as String;
  String getDatabaseId() => SettingsRepository.getDatabaseId()! as String;

  Future<void> showPrivacyPolicy() async {
    EasyLoading.show();
    try {
      launch(privacyPolicyUrl);
    } finally {
      launch(privacyPolicyUrl);
      EasyLoading.dismiss();
    }
  }
}
