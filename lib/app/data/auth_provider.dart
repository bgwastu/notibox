import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:notibox/app/config/constants.dart';

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
      if (e.response != null) {
        if (e.response!.statusCode == 401) {
          return false;
        }
      }
      throw e;
    }
  }
}
