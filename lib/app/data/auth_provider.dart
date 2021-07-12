import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:notibox/app/config/constants.dart';
import 'package:notibox/app/data/model/inbox_model.dart';
import 'package:notibox/app/data/repository/settings_repository.dart';

class AuthProvider {
  final _dio = Get.put(Dio());

  Future<bool> checkToken(String token) async {
    try {
      final response = await _dio.get(BASE_URL + 'users',
          options: Options(headers: {
            'Authorization': 'Bearer ' + token,
            'Notion-Version': NOTION_VERSION
          }));
      return response.statusCode == 200;
    } on DioError catch (e) {
      if (e.response!.statusCode == 401) {
        return false;
      }
      throw e;
    }
  }

  Future<List<Inbox>> getListInbox({required String databaseId}) async {
    final token = (await SettingsRepository.instance()).getToken();
    final res = await Dio().post('$BASE_URL/databases/$databaseId/query',
        options: Options(headers: {
          'Authorization': 'Bearer ' + token!,
          'Notion-Version': NOTION_VERSION
        }),
        data: {
          'sorts': [
            {'timestamp': 'created_time', 'direction': 'descending'}
          ]
        });
    return (res.data['results'] as List).map((e) => Inbox.fromMap(e)).toList();
  }

  Future createInbox({required Inbox inbox, required String databaseId}) async {
    final token = (await SettingsRepository.instance()).getToken();
    await Dio().post('$BASE_URL/pages',
        data: {
          'parent': {
            'database_id': databaseId,
          },
          'properties': inbox.toMap()
        },
        options: Options(headers: {
          'Authorization': 'Bearer ' + token!,
          'Notion-Version': NOTION_VERSION
        }));
  }
}
