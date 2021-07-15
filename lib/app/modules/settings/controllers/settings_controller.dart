import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notibox/app/data/repository/settings_repository.dart';

class SettingsController extends GetxController {
  void toggleDarkMode(bool isDarkMode) {
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
    SettingsRepository.setThemeMode(isDarkMode);
  }

  void updateToken(String token) => SettingsRepository.setToken(token);
  void updateDatabaseId(String databaseId) => SettingsRepository.setDatabaseId(databaseId);
  String getToken() => SettingsRepository.getToken()!;
  String getDatabaseId() => SettingsRepository.getDatabaseId()!;
}
