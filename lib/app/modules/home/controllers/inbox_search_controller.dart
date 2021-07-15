import 'package:get/get.dart';
import 'package:notibox/app/data/model/inbox_model.dart';
import 'package:notibox/app/data/notion_provider.dart';

class InboxSearchController extends GetxController {
  final _notionProvider = Get.put(NotionProvider());

  RxString searchQuery = ''.obs;
  
  Future<List<Inbox>> getListSuggestion() => _notionProvider.getListSuggestion(searchQuery.value); 

}
