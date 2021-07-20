import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:notibox/app/inbox/home_inbox/home_exception.dart';
import 'package:notibox/config/constants.dart';
import 'package:notibox/config/error_interceptor.dart';

class TokenService {
  final _dio = Get.put(Dio()..interceptors.add(ErrorInterceptor()));

  Future<bool> checkToken(String token) async {
    try {
      final response = await _dio.get('${baseUrl}users',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
            'Notion-Version': notionVersion
          }));
      return response.statusCode == 200;
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 401) {
          return false;
        }
      }
      throw HomeException.fromDioError(e);
    }
  }
}
