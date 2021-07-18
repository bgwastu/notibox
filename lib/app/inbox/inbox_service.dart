import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notibox/app/inbox/inbox_model.dart';
import 'package:notibox/app/onboarding/database_model.dart';
import 'package:notibox/app/settings/settings_repository.dart';
import 'package:notibox/config/constants.dart';

class InboxService {
  Dio? dio;
  String? token;
  String? databaseId;

  InboxService({this.dio, this.token, this.databaseId}) {
    dio ??= Get.put(Dio());
    refreshCredentials();
  }

  void refreshCredentials() {
    token = (SettingsRepository.getToken() ?? '') as String;
    databaseId = (SettingsRepository.getDatabaseId() ?? '') as String;
  }

  Future<List<Database>> getListDatabase() async {
    refreshCredentials();

    final res = await dio!.get('${baseUrl}databases',
        options: Options(headers: {
          'Authorization': 'Bearer ${token!}',
          'Notion-Version': notionVersion
        }));

    return (res.data['results'] as List)
        .map((e) => Database.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Select>> getListLabel() async {
    refreshCredentials();

    final res = await dio!.get('${baseUrl}databases/${databaseId!}',
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
    refreshCredentials();

    final cacheOptions = CacheOptions(
      store: token! == 'debug' ? MemCacheStore() : HiveCacheStore(null),
      policy: CachePolicy.refresh,
      hitCacheOnErrorExcept: [401, 403],
      maxStale: const Duration(days: 7),
      allowPostMethod: true,
    );
    final dio = this.dio!
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

    return (res.data['results'] as List)
        .map((e) => Inbox.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> createInbox({required Inbox inbox}) async {
    refreshCredentials();

    await dio!.post('${baseUrl}pages',
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
    refreshCredentials();

    await dio!.patch('$baseUrl${'pages/$pageId'}',
        data: {'properties': inbox.toMap()},
        options: Options(headers: {
          'Authorization': 'Bearer ${token!}',
          'Notion-Version': notionVersion
        }));
  }

  Future<void> deleteInbox({required String pageId}) async {
    refreshCredentials();

    await dio!.patch('$baseUrl${'pages/$pageId'}',
        data: {'archived': true},
        options: Options(headers: {
          'Authorization': 'Bearer ${token!}',
          'Notion-Version': notionVersion
        }));
  }

  Future<List<Inbox>> getListSuggestion(String query) async {
    refreshCredentials();
    final cacheOptions = CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.refresh,
      hitCacheOnErrorExcept: [401, 403],
      maxStale: const Duration(seconds: 5),
      priority: CachePriority.high,
      allowPostMethod: true,
    );

    final dio = this.dio!
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
    final listInbox = (res.data['results'] as List)
        .map((e) => Inbox.fromMap(e as Map<String, dynamic>));
    final filteredList = listInbox
        .where(
            (inbox) => inbox.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return filteredList;
  }
}
