import 'package:hive_flutter/hive_flutter.dart';

class SettingsRepository {

  static Box<dynamic> _box() =>
      Hive.box<dynamic>('settings');

  static void setToken(String token) => _box().put('token', token);
  static String? getToken() => _box().get('token');

  static void setDatabaseId(String databaseId) => _box().put('database_id', databaseId);
  static String? getDatabaseId() => _box().get('database_id');
  static void setThemeMode(bool isDarkMode) {
    print('darkmode: $isDarkMode');
    _box().put('dark_mode', isDarkMode);
  }
  static bool? isDarkMode() => _box().get('dark_mode');
}
