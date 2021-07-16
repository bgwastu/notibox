
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

    final res = await _dio.get('${baseUrl}databases',
        options: Options(headers: {
          'Authorization': 'Bearer ${token!}',
          'Notion-Version': notionVersion
        }));

    return (res.data['results'] as List)
        .map((e) => Database.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Select>> getListLabel() async {
    final databaseId = SettingsRepository.getDatabaseId();
    final token = SettingsRepository.getToken();

    final res = await _dio.get('${baseUrl}databases/${databaseId!}',
        options: Options(headers: {
          'Authorization': 'Bearer ${token!}',
          'Notion-Version': notionVersion
        }));
    final listLabel =
        (res.data['properties']['Label']['select']['options'] as List)
            .map<Select>((e) => Select.fromMap(e as Map<String, dynamic>))
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
      allowPostMethod: true,
    );

    final token = SettingsRepository.getToken();
    final databaseId = SettingsRepository.getDatabaseId();
    final dio = Dio()
      ..interceptors.add(DioCacheInterceptor(options: cacheOptions));

    final res = await dio.post('$baseUrl${'databases/$databaseId/query'}',
        options: Options(headers: {
          'Authorization': 'Bearer ${token!}',
          'Notion-Version': notionVersion
        }),
        data: {
          'sorts': [
            {'timestamp': 'created_time', 'direction': 'descending'}
          ]
        });

    return (res.data['results'] as List).map((e) => Inbox.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<void> createInbox({required Inbox inbox}) async {
    final token = SettingsRepository.getToken();
    final databaseId = SettingsRepository.getDatabaseId();
    await _dio.post('${baseUrl}pages',
        data: {
          'parent': {
            'database_id': databaseId!,
          },
          'properties': inbox.toMap()
        },
        options: Options(headers: {
          'Authorization': 'Bearer ${token!}',
          'Notion-Version': notionVersion
        }));
  }

  Future<void> updateInbox(
      {required Inbox inbox, required String pageId}) async {
    final token = SettingsRepository.getToken();
    await _dio.patch('$baseUrl${'pages/$pageId'}',
        data: {'properties': inbox.toMap()},
        options: Options(headers: {
          'Authorization': 'Bearer ${token!}',
          'Notion-Version': notionVersion
        }));
  }

  Future<void> deleteInbox({required String pageId}) async {
    final token = SettingsRepository.getToken();
    await _dio.patch('$baseUrl${'pages/$pageId'}',
        data: {'archived': true},
        options: Options(headers: {
          'Authorization': 'Bearer ${token!}',
          'Notion-Version': notionVersion
        }));
  }

  Future<List<Inbox>> getListSuggestion(String query) async {
    final token = SettingsRepository.getToken();
    final databaseId = SettingsRepository.getDatabaseId();

    final cacheOptions = CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.refresh,
      hitCacheOnErrorExcept: [401, 403],
      maxStale: const Duration(seconds: 5),
      priority: CachePriority.high,
      allowPostMethod: true,
    );

    final dio = Dio()
      ..interceptors.add(DioCacheInterceptor(options: cacheOptions));

    final res = await dio.post('$baseUrl${'databases/$databaseId/query'}',
        options: Options(headers: {
          'Authorization': 'Bearer ${token!}',
          'Notion-Version': notionVersion
        }),
        data: {
          'sorts': [
            {'timestamp': 'created_time', 'direction': 'descending'}
          ]
        });
    final listInbox =
        (res.data['results'] as List).map((e) => Inbox.fromMap(e as Map<String, dynamic>));
    final filteredList = listInbox
        .where(
            (inbox) => inbox.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return filteredList;
  }
}
