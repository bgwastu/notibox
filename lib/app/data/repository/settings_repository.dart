import 'package:hive_flutter/hive_flutter.dart';

class SettingsRepository {
  static final _box = Hive.box('settings');

  static void setToken(String token) => _box.put('token', token);
  static String? getToken() => _box.get('token');

  static void setDatabaseId(String databaseId) => _box.put('database_id', databaseId);
  static String? getDatabaseId() => _box.get('database_id');
}