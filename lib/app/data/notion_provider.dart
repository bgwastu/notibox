import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notibox/app/config/constants.dart';
import 'package:notibox/app/data/model/database_model.dart';
import 'package:notibox/app/data/model/inbox_model.dart';
import 'package:notibox/app/data/repository/settings_repository.dart';

class NotionProvider {
  final _dio = Get.put(Dio());

  Future<List<Database>> getListDatabase() async {
    final token = SettingsRepository.getToken();

    final res = await _dio.get(BASE_URL + 'databases',
        options: Options(headers: {
          'Authorization': 'Bearer ' + token!,
          'Notion-Version': NOTION_VERSION
        }));

    return (res.data['results'] as List)
        .map((e) => Database.fromMap(e))
        .toList();
  }

  Future<List<Select>> getListLabel() async {
    final databaseId = SettingsRepository.getDatabaseId();
    final token = SettingsRepository.getToken();

    final res = await _dio.get(BASE_URL + 'databases/' + databaseId!,
        options: Options(headers: {
          'Authorization': 'Bearer ' + token!,
          'Notion-Version': NOTION_VERSION
        }));
    final listLabel =
        (res.data['properties']['Label']['select']['options'] as List)
            .map<Select>((e) => Select.fromMap(e))
            .toList();
    final noLabel =
        Select(id: 'no-label', name: 'No Label', color: Colors.grey);

    return [noLabel, ...listLabel];
  }

  Future<List<Inbox>> getListInbox() async {
    final cacheOptions = CacheOptions(
      store: HiveCacheStore(null),
      policy: CachePolicy.refresh,
      hitCacheOnErrorExcept: [401, 403],
      maxStale: const Duration(days: 7),
      priority: CachePriority.normal,
      cipher: null,
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      allowPostMethod: true,
    );

    final token = SettingsRepository.getToken();
    final databaseId = SettingsRepository.getDatabaseId();
    final dio = _dio
      ..interceptors.add(DioCacheInterceptor(options: cacheOptions));

    final res = await dio.post(BASE_URL + 'databases/$databaseId/query',
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

  Future createInbox({required Inbox inbox}) async {
    final token = SettingsRepository.getToken();
    final databaseId = SettingsRepository.getDatabaseId();
    await _dio.post(BASE_URL + 'pages',
        data: {
          'parent': {
            'database_id': databaseId!,
          },
          'properties': inbox.toMap()
        },
        options: Options(headers: {
          'Authorization': 'Bearer ' + token!,
          'Notion-Version': NOTION_VERSION
        }));
  }
}
