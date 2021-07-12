
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:notibox/app/config/constants.dart';
import 'package:notibox/app/data/model/database_model.dart';
import 'package:notibox/app/data/repository/settings_repository.dart';

class NotionProvider {
  final _dio = Get.put(Dio());

  Future<List<Database>> getListDatabase() async {
    final token = (await SettingsRepository.instance()).getToken();

    final res = await _dio.get(BASE_URL + 'databases',
        options: Options(headers: {
          'Authorization': 'Bearer ' + token!,
          'Notion-Version': NOTION_VERSION
        }));

    return (res.data['results'] as List)
        .map((e) => Database.fromMap(e))
        .toList();
  }
}
