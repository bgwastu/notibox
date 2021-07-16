import 'package:hive_flutter/hive_flutter.dart';

class SettingsRepository {

  static Box<dynamic> _box() =>
      Hive.box<dynamic>('settings');

  static void setToken(String token) => _box().put('token', token);
  static String? getToken() => _box().get('token') as String;

  static void setDatabaseId(String databaseId) => _box().put('database_id', databaseId);
  static String? getDatabaseId() => _box().get('database_id') as String;
  static void setThemeMode({required bool isDarkMode}) {
    _box().put('dark_mode', isDarkMode);
  }
  static bool? isDarkMode() => _box().get('dark_mode') as bool;
}
