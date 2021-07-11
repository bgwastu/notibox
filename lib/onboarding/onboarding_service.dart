import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notibox/config/constants.dart';
import 'package:notibox/global_provider.dart';

final authServiceProvider = Provider<OnboardingService>((ref) {
  final dio = ref.watch(dioProvider);

  return OnboardingService(dio);
});

class OnboardingService {
  final Dio _dio;

  OnboardingService(this._dio);

  Future<bool> checkToken(String token) async {
    final _headers = {
      'Authorization': 'Bearer ' + token,
      'Notion-Version': NOTION_VERSION
    };
    try {
      final url = BASE_URL + 'users';
      final response = await _dio.get(url, options: Options(headers: _headers));
      return response.statusCode == 200;
    } on DioError catch (e) {
      if (e.response!.statusCode == 401) {
        return false;
      }
      throw e;
    }
  }
}
