import 'package:hive_flutter/hive_flutter.dart';

class SettingsRepository {

  static Box<String> instance() =>
      Hive.box<String>('settings');

  static void setToken(String token) => instance().put('token', token);
  static String? getToken() => instance().get('token');

  static void setDatabaseId(String databaseId) => instance().put('database_id', databaseId);
  static String? getDatabaseId() => instance().get('database_id');
}
