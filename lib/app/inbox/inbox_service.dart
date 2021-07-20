import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notibox/app/inbox/home_inbox/home_exception.dart';
import 'package:notibox/app/inbox/inbox_model.dart';
import 'package:notibox/app/onboarding/database_model.dart';
import 'package:notibox/app/settings/settings_repository.dart';
import 'package:notibox/config/constants.dart';
import 'package:notibox/config/error_interceptor.dart';

class InboxService {
  Dio? dio;
  String? token;
  String? databaseId;

  InboxService({this.dio, this.token, this.databaseId}) {
    refreshCredentials();
    dio ??= Get.put(Dio()
      ..options = BaseOptions(headers: {
        'Authorization': 'Bearer ${token!}',
        'Notion-Version': notionVersion
      }, baseUrl: baseUrl)
      ..interceptors.add(ErrorInterceptor()));
  }

  void refreshCredentials() {
    if (token != 'test' || databaseId != 'test') {
      token = (SettingsRepository.getToken() ?? '') as String;
      databaseId = (SettingsRepository.getDatabaseId() ?? '') as String;
    }
  }

  Future<List<Database>> getListDatabase() async {
    refreshCredentials();

    try {
      final res = await dio!.get('databases');

      return (res.data['results'] as List)
          .map((e) => Database.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (e) {
      throw HomeException.fromDioError(e);
    }
  }

  Future<List<Select>> getListLabel() async {
    refreshCredentials();

    try {
      final res = await dio!.get('databases/${databaseId!}');
      final listLabel =
          (res.data['properties']['Label']['select']['options'] as List)
              .map<Select>((e) => Select.fromMap(e as Map<String, dynamic>))
              .toList();
      final noLabel =
          Select(id: 'no-label', name: 'No Label', color: Colors.grey);

      return [noLabel, ...listLabel];
    } on DioError catch (e) {
      throw HomeException.fromDioError(e);
    }
  }

  Future<List<Inbox>> getListInbox() async {
    refreshCredentials();

    try {
      final cacheOptions = CacheOptions(
        store: token! == 'test' ? MemCacheStore() : HiveCacheStore(null),
        policy: CachePolicy.refresh,
        hitCacheOnErrorExcept: [401, 403],
        maxStale: const Duration(days: 7),
        allowPostMethod: true,
      );
      final dio = this.dio!
        ..interceptors.add(DioCacheInterceptor(options: cacheOptions));

      final res = await dio.post('databases/$databaseId/query', data: {
        'sorts': [
          {'timestamp': 'created_time', 'direction': 'descending'}
        ]
      });

      return (res.data['results'] as List)
          .map((e) => Inbox.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (e) {
      throw HomeException.fromDioError(e);
    }
  }

  Future<void> createInbox({required Inbox inbox}) async {
    refreshCredentials();

    try {
      await dio!.post('pages', data: {
        'parent': {
          'database_id': databaseId!,
        },
        'properties': inbox.toMap()
      });
    } on DioError catch (e) {
      throw HomeException.fromDioError(e);
    }
  }

  Future<void> updateInbox(
      {required Inbox inbox, required String pageId}) async {
    refreshCredentials();

    try {
      await dio!.patch('pages/$pageId', data: {'properties': inbox.toMap()});
    } on DioError catch (e) {
      throw HomeException.fromDioError(e);
    }
  }

  Future<void> deleteInbox({required String pageId}) async {
    refreshCredentials();

    try {
      await dio!.patch('pages/$pageId', data: {'archived': true});
    } on DioError catch (e) {
      throw HomeException.fromDioError(e);
    }
  }

  Future<List<Inbox>> getListSuggestion(String query) async {
    refreshCredentials();
    try {
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

      final res = await dio.post('databases/$databaseId/query', data: {
        'sorts': [
          {'timestamp': 'created_time', 'direction': 'descending'}
        ]
      });
      final listInbox = (res.data['results'] as List)
          .map((e) => Inbox.fromMap(e as Map<String, dynamic>));
      final filteredList = listInbox
          .where((inbox) =>
              inbox.title.toLowerCase().contains(query.toLowerCase()))
          .toList();

      return filteredList;
    } on DioError catch (e) {
      throw HomeException.fromDioError(e);
    }
  }
}
