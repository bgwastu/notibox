import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:notibox/app/inbox/inbox_service.dart';
import 'package:notibox/config/constants.dart';

import '../../test_constants.dart';

void main() {
  
  // DO NOT CHANGE THIS
  const token = 'test';
  const databaseId = 'test';

  final dio = Dio();
  final dioAdapter = DioAdapter();
  dio.httpClientAdapter = dioAdapter;
  final inboxService =
      InboxService(dio: dio, databaseId: databaseId, token: token);

  test('getListDatabase', () async {
    dioAdapter.onGet(
      'databases',
      (request) => request.reply(200, getListDatabaseResponse),
      headers: {
        'Authorization': 'Bearer $token',
        'Notion-Version': notionVersion
      },
    );
    final listDatabase = await inboxService.getListDatabase();
    expect(listDatabase, isNotEmpty);
  });

  test('getListLabel', () async {
    dioAdapter.onGet(
      'databases/$databaseId',
      (request) => request.reply(200, getDatabaseResponse),
      headers: {
        'Authorization': 'Bearer $token',
        'Notion-Version': notionVersion
      },
    );

    final listLabel = await inboxService.getListLabel();
    expect(listLabel, isNotEmpty);
  });

  test('getListInbox', () async {
    dioAdapter.onPost('databases/$databaseId/query',
        (request) => request.reply(200, getListInboxResponse),
        headers: {
          'Authorization': 'Bearer $token',
          'Notion-Version': notionVersion,
          Headers.contentTypeHeader: Headers.jsonContentType,
        },
        data: Matchers.any);

    final listLabel = await inboxService.getListInbox();
    expect(listLabel, isNotEmpty);
  });

  test('getListSuggestion', () async {
    dioAdapter.onPost('databases/$databaseId/query',
        (request) => request.reply(200, getListInboxResponse),
        headers: {
          'Authorization': 'Bearer $token',
          'Notion-Version': notionVersion,
          Headers.contentTypeHeader: Headers.jsonContentType,
        },
        data: Matchers.any);

    final listLabel = await inboxService.getListLabel();
    expect(listLabel, isNotEmpty);
  });
}
