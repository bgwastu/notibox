import 'package:get/get.dart';
import 'package:notibox/app/config/constants.dart';

class AuthProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = BASE_URL;
  }

  Future<bool> checkToken(String token) async {
    final _headers = {
      'Authorization': 'Bearer ' + token,
      'Notion-Version': NOTION_VERSION
    };

    try {
      final response = await httpClient.get('users', headers: _headers);
      return response.statusCode == 200;
    } catch (e) {
      throw e;
    }
  }
}
