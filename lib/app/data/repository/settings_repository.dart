import 'package:hive_flutter/hive_flutter.dart';

class SettingsRepository {
  Box box;
  SettingsRepository({
    required this.box,
  });

  static Future<SettingsRepository> instance() async {
    final box = await Hive.openBox('settings');
    return SettingsRepository(box: box);
  }

  void setToken(String token) => box.put('token', token);
  String getToken() => box.get('token');

  void setDatabaseId(String databaseId) => box.put('database_id', databaseId);
  String getDatabaseId() => box.get('database_id');
}
